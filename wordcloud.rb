#!/usr/bin/env ruby
#
require 'sinatra'
require 'sinatra/activerecord'
require 'base64'

set :database, 'sqlite3:///words.db'
set :server, :thin
set :erb, :layout => false

class Word < ActiveRecord::Base
end

def scale(count)
    min = 10
    max = 120.0
    (((max - min)/(@words.first.count - 1))*(count - @words.last.count)+ min).to_i
end

def clean_words(words)
    boring_words = %q{hello hi the and a that i it not he as you this but his they her she or an will my one all would there their to is if are be of with from for at in on with by up about into over after beneth under above any your other us we have when can subject do what like}
    word_array = words.gsub(/[^\w\s]/, '').downcase.split() - boring_words.split()
    return word_array
end

get '/style.css' do
end

get '/' do
    @words = Word.order("count DESC").limit(500)
    erb :index
end

get '/cloud' do
    @words = Word.where(:deleted => false).order('count desc').limit(500)
    erb :cloud
end

get '/delete_all' do
    Word.delete_all
    redirect '/'
end

get '/delete/:id' do |id|
    word = Word.find(id)
    word.deleted = true
    word.save
    redirect '/cloud'
end

get '/deleted' do
    @words = Word.where(:deleted => true)
    erb :deleted
end

get '/restore/:id' do |id|
    word = Word.find(id)
    word.deleted = false
    word.save
    redirect '/deleted'
end

post '/post_comments' do
    words = Base64.decode64(params["words"])
    word_array = clean_words(words)
    word_array.each do |word|
        foo = Word.where(:word => word.downcase).first_or_create()
        if foo.count == nil
            foo.count = 1
        else
            foo.count += 1
        end
        foo.save
    end
end
