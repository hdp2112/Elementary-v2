require "ibm_watson/authenticators"
require "ibm_watson/natural_language_understanding_v1"
include IBMWatson

class WatsonsController < ApplicationController 

  def index
    @watsons = Watson.all
  end
  
  def new
    @watson = Watson.new
  end

  def create
    #response(watson.text)
    @watson = params["watson"]["text"]

    authenticator = Authenticators::IamAuthenticator.new(apikey: "")
    natural_language_understanding = NaturalLanguageUnderstandingV1.new(
    version: "2019-07-12",
    authenticator: authenticator)

    natural_language_understanding.service_url = ""
    
    response = natural_language_understanding.analyze(
      text: "#{@watson}",
      features: {emotion: {}, categories: {limit:3}, entities: {limit:3}, keywords: {limit:3}, relations: {limit:3},  sentiment:{}})
    @result_hash = response.result
    
    Watson.create(
      text: @watson,
      sentiment_label: @result_hash["sentiment"]['document']['label'],
      sentiment_score: @result_hash["sentiment"]['document']['score'],
      emotion_sadness: @result_hash['emotion']['document']['emotion']['sadness'],
      emotion_joy: @result_hash['emotion']['document']['emotion']['joy'],
      emotion_fear: @result_hash['emotion']['document']['emotion']['fear'],
      emotion_disgust: @result_hash['emotion']['document']['emotion']['disgust'],
      emotion_anger: @result_hash['emotion']['document']['emotion']['anger'],
      keywords: @result_hash['keywords'],
      categories: @result_hash['categories'],
      entities: @result_hash['entities']
    )
    redirect_to watson_path(Watson.last.id)
  end

  def edit
    @watson = Watson.find(params[:id])
  end

  def update
    @watson = Watson.find(params[:id])
    @sun_text = params["watson"]["text"]

    authenticator = Authenticators::IamAuthenticator.new(apikey: "")
    natural_language_understanding = NaturalLanguageUnderstandingV1.new(
    version: "2019-07-12",
    authenticator: authenticator)

    natural_language_understanding.service_url = ""
    
    response = natural_language_understanding.analyze(
      text: @sun_text,
      features: {emotion: {}, categories: {limit:3}, entities: {limit:3}, keywords: {limit:3}, relations: {limit:3},  sentiment:{}})
    @result_hash = response.result
    
    @watson.update(
      text: @sun_text,
      sentiment_label: @result_hash["sentiment"]['document']['label'],
      sentiment_score: @result_hash["sentiment"]['document']['score'],
      emotion_sadness: @result_hash['emotion']['document']['emotion']['sadness'],
      emotion_joy: @result_hash['emotion']['document']['emotion']['joy'],
      emotion_fear: @result_hash['emotion']['document']['emotion']['fear'],
      emotion_disgust: @result_hash['emotion']['document']['emotion']['disgust'],
      emotion_anger: @result_hash['emotion']['document']['emotion']['anger'],
      keywords: @result_hash['keywords'],
      categories: @result_hash['categories'],
      entities: @result_hash['entities']
    )
    redirect_to watson_path(@watson)
  end

  def show
    @watson = Watson.find(params[:id])

  end

  private

  def strong_params
    params.require(:watson).permit(:text, :sentiment_label, :sentiment_score, :emotion_sadness, :emotion_joy, :emotion_fear, :emotion_disgust, :emotion_anger, :keywords, :categories, :entities)
  end

end