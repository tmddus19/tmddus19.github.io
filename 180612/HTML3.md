## 로또번호 추천 서비스

- 로또정보 (인터넷 공개)

  - 노가다 -> 손수 직접 옮기기

    시간이 많이 걸리고, 큰 데이터 옮기기에 적합x

  - API(Programmable Interface) 방식 (가장 선호)

    정보제공자가 기꺼이 정보를 내놓는 경우

    가져가기 쉽게 만들어놓음 (프로그래밍을 통해서)

  - 스크랩 / 크롤링

    정보제공자가 기꺼이 정보를 내놓지 않은 경우 (but 웹에는 있는 경우)

    긁어, 뺏어 올 수 있음

  => 웹에 올라온 정보는 모두 자동화하여 가져올 수 있다.

  해쉬: 이름표를 가진 자료 묶음, key  & value      ex) bnosNo : 24   ->   (key) : (value)

  구글 확장프로그램에서 json viewer를 다운받으면 API를 json포맷으로 볼 수 있다.

  #### 노가다 방식

- app.rb에

  require 'sinatra'

  get '/' do
      erb :index
  end

  get '/result' do
      @lotto = (1..45).to_a.sample(6).sort
      @winner = [5, 10, 13, 21, 39, 43].sort         일등번호

    count = 0                                           
      @winner.each do |x|
          @lotto.each do |y|
              if x == y                                                =>   count = (@winner & @lotto).size로 쓸 수 있음 (리팩토링)

  ​                count += 1
              end
          end
      end
      

      if count ==6
          @you = "1등"
      elsif count == 5 and @lotto.include?(@bonus)
      elsif count == 5
          @you = "3등"
      elsif count == 4
          @you = "4등"
      elsif count == 3
          @you = "5등"
      else
          @you = "꽝"
      end 
  ​    erb :result 
  end

  - .include?()    : ()안의 숫자를 포함하고 있는지비교 맞으면true 틀리면 false

- index.erb에

  <!DOCTYPE html>
  <html>
      <head>
          <title>로또번호 추천 서비스</title>
      </head>
      <body>
         <*a href = "/result"> 추천받기</a>         *제외
      </body>
  </html>

  

- result.erb에

  <!DOCTYPE html>
  <html>
      <head>
          <title>로또번호 추천 서비스</title>
      </head>
      <body>
          <p><%= @lotto %></p>
          <p><%= @winner %></p>

  ​    </body>
  </html>

  API방식

- app.rb에

  get '/api' do

  ​    url = "http://www.nlotto.co.kr/common.do?method=getLottoNumber&drwNo="
      drw = "810"   

  ​    response = HTTParty.get(url + drw)
      result = JSON.parse(response.body)

  ​    @lotto = []
      6.times do |x|  

  ​            @lotto.push(result["drwtNo#{x + 1}"]) 
      end    

  ​    @bonus = result["bnusNo"]

  ​     erb :api 
  end   추가

- api.erb에

  <!DOCTYPE html>
  <html>
      <head>
          <title>로또번호 추천 서비스</title>
          <meta charset="utf-8">
      </head>
      <body>
          <h1>API로 로또 번호 받아요</h1>
          <p> 로또 번호 6개 출력</p>
      </body>
  </html>

  - json을 해쉬로 바꿀 수 있다

    JSON.parse(response.body)            : 가 =>로 바뀜



# bootstrap

- Documentation 안의 components안의 Jombotron을 카피한다.

  index.erb <body>부분에 넣어준다.

![1528781338342](C:\Users\student\AppData\Local\Temp\1528781338342.png)

- Navbar 추가하기

  nav.erb 에 카피한것을 넣어준다.

  <body>부분에 <%= erb : nav%>를 넣어준다.

![1528781564898](C:\Users\student\AppData\Local\Temp\1528781564898.png)

- 사용하기전에 bootstrapCDN에 있는 html코드들을 다 카피해서 bootstrap.erb에 넣어준다.

  <%= erb : bootstrap %>을 <head>부분마다 넣어주면 항상 떠있게된다.

### eu central bank를 이용해서 환율하는 서비스 만들기

-  gem install eu_central_bank를 깔아준다.

- app.rb에 

  require 'sinatra'
  require 'eu_central_bank'

  get '/' do
      erb :index
  end

  get '/ex' do
     erb :exchange 
  end

  get '/convert' do
      @from = params[:from]
      @to = params[:to]
      @amount = params[:amount].to_f
      bank = EuCentralBank.new
      bank.update_rates                                 :현재시간을 기준으로 환율정보를 가져온다.
      @result = bank.exchange(@amount, @from, @to).to_f            :  .to_f  소수점까지 보여준다.
      erb :convert 
  end

  get '/stock' do
      
  end

  get '/weather' do
      
  end

- index.erb에

  <!DOCTYPE html>
  <html>
      <head>
          <title></title>
          <meta charset="utf-8"
      </head>
      <body>
           <*a href="/ex">환율정보</a>                               *빼기
          <*a href="/stock">주식정보</a>
          <*a href="/weather">날씨정보</a>   
      </body>
  </html>

- exchange.erb에

  <!DOCTYPE html>
  <html>
      <head>
          <title></title>
          <meta charset="utf-8">
      </head>
      <body>
          <h1>환율 정보 페이지</h1>
          <form action="/convert">
              <p>기준통화</p>
              <select name="from">
                  <option value="USD">달러</option>
                  <option value="EUR">유로</option>
                  <option value="JPY">엔</option>
              </select>
              <select name="to">
                  <p>환전통화</p>
                  <option value="USD">달러</option>
                  <option value="EUR">유로</option>
                  <option value="JPY">엔</option>
              </select>
              <p>금액</p>
              <input type="text" name="amount">
              <input type="submit">
          </form>
      </body>
  </html>

  - input select box  사용법

    <select>

    ​      <option></option>

    </select>

- convert.erb 에

  <!DOCTYPE html>
  <html>
      <head>
          <title></title>
          <meta charset="utf-8">
      </head>
      <body>
          From : <%= @from %>
          To : <%= @to %>
          Amount : <%= @amount %>
          결과 : <%= @result %>
      </body>
  </html>

![1528788359711](C:\Users\student\AppData\Local\Temp\1528788359711.png)



![1528788380101](C:\Users\student\AppData\Local\Temp\1528788380101.png)



![1528788398651](C:\Users\student\AppData\Local\Temp\1528788398651.png)



