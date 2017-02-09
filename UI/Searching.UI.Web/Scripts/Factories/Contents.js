function Contents($http,ApiService,$location,$anchorScroll) {
    var Contents = function (filter) {
        this.items = [];
        this.busy = false;
        this.endpage = false;
        this.filter = filter;
    };                                                                                            
    
    var items = [];
    Contents.prototype.NextPage = function () {
        if (this.endpage) return;
        if (this.busy) return;
        this.busy = true;
        ApiService.AnnFilter(this.filter)
      .success(function (response) {

          if (response.length == 0) {
              this.endpage = true; return;
          }
          else
          {
              if (response.length < 6 && this.filter.NPage==1) {
                  this.busy = true;
              } else
              {
                  this.busy = false;
              }
              console.log('Номер страницы:', this.filter.NPage);
              this.endpage = false;
              this.filter.NPage++;
          }

          console.log('length', response.length);
          for (var i = 0; i < response.length; i++) {
              //var testDate = new Date(Date.parse(response[i]['Date_Announcing']));
              //var testDate = new Date(parseInt(response[i]['Date_Announcing']));
              //var testDate = new Date(parseInt(response[i]['Date_Announcing'].substr(6)));
              //response[i]['Date_Announcing'] = testDate;
              this.items.push(response[i]);
              
          }
          
          
      }.bind(this)); 
          console.log('items:', this.items);
    }

    Contents.prototype.ScrollTo = function (scrollLocation) {
        $location.hash(scrollLocation);
        $anchorScroll();
    }

    Contents.prototype.LoadMore = function () {
        ApiService.AnnFilter(this.filter)
        .success(function (response) {
            if (response.length == 0) { console.log('Нету больше объявлений'); return; } else
            {
                this.endpage = false;
                Filter.NPage++;
            }
            for (var i = 0; i < response.length; i++) {
                this.items.push(response[i]);

            }
            this.busy = false;
        }.bind(this));
    }
    return Contents;
};
Contents.$inject = ['$http','ApiService','$location','$anchorScroll'];
    