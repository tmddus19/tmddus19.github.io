require 'sinatra'
require 'httparty'

get '/' do
   erb :index 
end

get '/api' do
    url = "http://www.nlotto.co.kr/common.do?method=getLottoNumber&drwNo="
    drw = "810"
   
    response = HTTParty.get(url + drw)
    result = JSON.parse(response.body)
    
    @lotto = []
    6.times do |x|
        @lotto.push(result["drwNo#{x+1}"]) 
    end
    @bonus = result["bnusNo"]
    # 1. HTTParty.get() => 로또 정보가 담겨있는 json 파일을 요청해서 받아온다.
    # 2. 받아온 응답(response) .body 파트에 담겨있는 json을 JSON.parse()를 통해 루비 Hash로 바꾼다.
    # 3. Hash 담겨 있는 정보들을 뽑아서 @lotto = [] 에 담는다(push())
    #냄새 1 : 반복문을 써서 다음 코드를 간단하게 하시오.
    # 4. Hash 담겨 있는 보너스 번호를 @bonus에 넣는다.
    # 5. @lotto 와 @bonus를 api.erb에 넣어서 출력한다.
    
    erb :api
end

get '/result' do
    @lotto = (1..45).to_a.sample(6).sort
    @winner = [5, 10, 13, 21, 39, 43].sort
    @bonus = 11
    
    count = (@winner & @lotto).size
    
    if count == 6
        @you = "1등"
    elsif count == 5 and @lotto.include?(@bonus) # 보너스번호(@bonus)가 우리 추천 번호(@lotto)에 있는지 (@lotto가 @bonus를 포함하니?)
        @you = "2등"
    elsif count == 5
        @you = "3등"
    elsif count == 4
        @you = "4등"
    elsif count == 3
        @you = "5등"
    else
        @you = "꽝"
    end
    
    erb :result
end

# count = 0
# 추천된 배열에 있는 요소를 하나씩 돌면서
#   해당하는 요소가 1등 배열에도 있는지 본다
#     만약에 있으면 count += 1


