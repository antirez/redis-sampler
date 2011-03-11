#!/usr/bin/ruby

# Copyright (c) 2011, Salvatore Sanfilippo
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of Redis nor the names of its contributors may be
#       used to endorse or promote products derived from this software without
#       specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
# TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

require 'rubygems'
require 'redis'

class RedisSampler
    def initialize(r,samplesize)
        @redis = r
        @samplesize = samplesize
        @types = {}
        @zset_card = {}
        @zset_elesize = {}
        @list_len = {}
        @list_elesize = {}
        @hash_len = {}
        @hash_fsize = {}
        @hash_vsize = {}
        @set_card = {}
        @set_elesize = {}
        @string_elesize = {}
    end

    def incr_freq_table(hash,item)
        hash[item] = 0 if !hash[item]
        hash[item] += 1
    end

    def sample
        @samplesize.times {
            k = @redis.randomkey
            t = @redis.type(k)
            incr_freq_table(@types,t)
            case t
            when 'zset'
                incr_freq_table(@zset_card,@redis.zcard(k))
                incr_freq_table(@zset_elesize,@redis.zrange(k,0,0)[0].length)
            when 'set'
                incr_freq_table(@set_card,@redis.scard(k))
                incr_freq_table(@set_elesize,@redis.srandmember(k).length)
            when 'list'
                incr_freq_table(@list_len,@redis.llen(k))
                incr_freq_table(@list_elesize,@redis.lrange(k,0,0)[0].length)
            when 'hash'
                l = @redis.hlen(k)
                incr_freq_table(@hash_len,l)
                if l < 32
                    field = @redis.hkeys(k)[0]
                    incr_freq_table(@hash_fsize,field.length)
                    incr_freq_table(@hash_vsize,@redis.hget(k,field).length)
                else
                    incr_freq_table(@hash_fsize,'unknown')
                    incr_freq_table(@hash_vsize,'unknown')
                end
            when 'string'
                incr_freq_table(@string_elesize,@redis.strlen(k))
            end
        }
    end

    def perc(val,tot)
        sprintf("%.2f%%",val*100/tot.to_f)
    end

    def render_freq_table(title,hash)
        puts "\n#{title.upcase}\n#{"="*title.length}\n"
        h = hash.sort{|a,b| b[1]<=>a[1]}
        i = 0
        tot = 0
        h.each{|k,v| tot += v}
        partial = 0
        h.each{|k,v|
            partial += v
            s = " #{k}: #{v} (#{perc v,tot})"
            s += " " * (25 - s.length) if s.length < 25
            print s
            i += 1
            puts "" if i % 3 == 0
            break if i >= 21 and v/@samplesize.to_f < 0.005
        }
        puts "" if i % 3 != 0
        if i != h.length
            puts "(suppressed #{h.length-i} items with perc < 0.5% for a total of #{perc tot-partial,tot})"
        end
    end

    def compute_avg(hash)
        # Compute average
        min = max = nil
        avg = 0
        items = 0
        hash.each{|k,v|
            next if k == 'unknown'
            avg += k*v
            items += v
            min = k if !min or min > k
            max = k if !max or max < k
        }
        avg /= items.to_f
        # Compute standard deviation
        stddev = 0
        hash.each{|k,v|
            next if k == 'unknown'
            stddev += ((k-avg)**2)*v
        }
        stddev = Math.sqrt(stddev/items.to_f)
        return {:avg => avg, :stddev => stddev, :min => min, :max => max}
    end

    def render_avg(hash)
        data = compute_avg(hash)
        printf "Average: %.2f Standard Deviation: %.2f",data[:avg],data[:stddev]
        puts ""
        puts "Min: #{data[:min]} Max: #{data[:max]}"
    end

    def stats
        render_freq_table("Types",@types)
        if @string_elesize.length != 0
            render_freq_table("Strings, size of values",@string_elesize)
            render_avg(@string_elesize)
        end
        if @list_len.length != 0
            render_freq_table("Lists, number of elements",@list_len)
            render_avg(@list_len)
            render_freq_table("Lists, size of elements",@list_elesize)
            render_avg(@list_elesize)
        end
        if @set_card.length != 0
            render_freq_table("Sets, number of elements",@zset_card)
            render_avg(@set_card)
            render_freq_table("Sets, size of elements",@set_elesize)
            render_avg(@set_elesize)
        end
        if @zset_card.length != 0
            render_freq_table("Sorted sets, number of elements",@zset_card)
            render_avg(@zset_card)
            render_freq_table("Sorted sets, size of elements",@zset_elesize)
            render_avg(@zset_elesize)
        end
        if @hash_len.length != 0
            render_freq_table("Hashes, number of fields",@hash_len)
            render_avg(@hash_len)
            render_freq_table("Hashes, size of fields",@hash_fsize)
            render_avg(@hash_fsize)
            render_freq_table("Hashes, size of values",@hash_vsize)
            render_avg(@hash_vsize)
        end
        puts ""
    end
end

if ARGV.length != 4
    puts "Usage: redis-sampler.rb <host> <port> <dbnum> <sample_size>"
    exit 1
end

redis = Redis.new(:host => ARGV[0], :port => ARGV[1].to_i, :db => ARGV[2].to_i)
sampler = RedisSampler.new(redis,ARGV[3].to_i)
puts "Sampling #{ARGV[0]}:#{ARGV[1]} DB:#{ARGV[2]} with #{ARGV[3]} RANDOMKEYS"
sampler.sample
sampler.stats
