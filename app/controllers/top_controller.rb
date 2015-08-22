class TopController < ApplicationController
    require 'rakuten_web_service'
    before_action :get_categoryname, only: [:index , :category , :itemlist , 
                                            :itemshow , :rankingshow , :caterankshow , :searchshow]
    #トップページ商品一覧表示アクション 
    def index
        #ジャンルコードを指定して商品一覧を取得する 
         #@items = RakutenWebService::Ichiba::Item.search(:genreId => '100316')
        
        #表示フラグ（キーワード検索時は JSONデータを表示する） 
        @view_sw = nil
        #キーワードを指定して商品一覧を取得する
        if params[:search].present?
            $keyword = params[:search]
            @view_sw = true
            get_searchitem($keyword,1)
            #@items = RakutenWebService::Ichiba::Item.search(:keyword =>  $keyword ,:page => '1')
            @title_info = "#{$keyword}の検索結果"
        else
            #総合ランキング順に商品データ (1-10)を取得する
             @title_info = "リアルタイムランキング"
             $keyword = nil
             @items = RakutenWebService::Ichiba::Item.ranking(:page => 1)
        end
    end
    
    #カテゴリー一覧表示アクション 
    def category
        
    end
    
    #選択カテゴリー商品一覧表示アクション 
    def itemlist
        #カテゴリー idをグローバル変数に退避する
        $category_id = params[:categoryid]
        
        #パラメータで渡されたカテゴリーコードのカテゴリー名を取得する 
        @janru_name = RakutenWebService::Ichiba::Genre[params[:categoryid]].name
        #選択したカテゴリーのサブカテゴリを取得する 
        #@janru_items = RakutenWebService::Ichiba::Genre[params[:categoryid]]
        
        #選択したカテゴリーの商品一覧を取得する 
        #@janru_items = RakutenWebService::Ichiba::Item.search(:genreId => params[:categoryid])
        
        @items = RakutenWebService::Ichiba::Item.ranking(:genreId => params[:categoryid])
        @janru = get_subcategory(params[:categoryid])
    end
    
    #選択商品詳細画面表示アクション 
    def itemshow
        #商品コードを指定して商品の詳細を取得する 
        @item = RakutenWebService::Ichiba::Item.search(:itemCode => params[:itemid])
    end
    
    #総合ランキング表示順位選択時アクション 
    def rankingshow
        @items = RakutenWebService::Ichiba::Item.ranking(:page => params[:page])
        @title_info = "リアルタイムランキング"
        render 'index'
    end
    
    #カテゴリーランキング表示順位選択時アクション 
    def caterankshow
        @items = RakutenWebService::Ichiba::Item.ranking(:genreId => params[:categoryid] ,
                                                         :page => params[:page])
        #パラメータで渡されたカテゴリーコードのカテゴリー名を取得する 
        @janru_name = RakutenWebService::Ichiba::Genre[params[:categoryid]].name
        #パラメーターで渡されたカテゴリコードのサブカテゴリ一覧を取得する 
        @janru = get_subcategory(params[:categoryid])
        render 'itemlist'
    end
    
    #キーワード検索表示順位選択時アクション 
    def searchshow
        #@items = RakutenWebService::Ichiba::Item.search(:keyword =>  $keyword ,:page => params[:page])
        get_searchitem($keyword,params[:page])
        @title_info = "#{$keyword}の検索結果"
        @view_sw = true
        render 'index'
    end
    
    
    private
    def get_categoryname
        #全てのルートカテゴリー一覧を取得する 
         @janru = RakutenWebService::Ichiba::Genre.root
    end
    
    private
    def get_subcategory(categoryid)
        #サブカテゴリー一覧を取得する 
        RakutenWebService::Ichiba::Genre[categoryid]
    end
    
    #キーワード検索時データ取得メソッド 
    private
    def get_searchitem(keyword,page_no)
    	httpClient = HTTPClient.new

        @jsonData = nil
        @errorMeg = nil

        begin
          data = httpClient.get_content('https://app.rakuten.co.jp/services/api/IchibaItem/Search/20140222', {
              'applicationId' => APP_ID,
              'affiliateId'   => AFF_ID,
              'keyword'       => keyword,
              'page'          => page_no
          })
          @jsonData = JSON.parse data
        rescue HTTPClient::BadResponseError => e
        rescue HTTPClient::TimeoutError => e
        end
    end
end
