using Caliburn.Micro;
using Searching.UI.WinPhoneClient.Logics.Client;
using SearchingLibrary;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Searching.UI.WinClient.ViewModels
{
    public class AnnouncingViewModel : Screen
    {
        YourAnnViewModel _fullAnn = new YourAnnViewModel();
        private readonly INavigationService navigationService;
        private bool _categoriesGrid=true;
        private bool _announcingGrid = false;
        private List<Categories> _categories;
        private List<Announcing> _ann;
        private Categories _selectedCategories;
        private bool _loadIndicator;
        public Announcing _selectedAnn;
        public Announcing _annFull;
        FilterViewModel _filter = new FilterViewModel();
        public AnnouncingViewModel(INavigationService navigationService)
        {
            this.navigationService = navigationService;
            DisplayName = "Категории";
        }

        public List<Announcing> ListAnnouncing
        {
            get
            {
                return _ann;
            }
            set
            {
                _ann = value;
                NotifyOfPropertyChange(()=> ListAnnouncing);
            }
        }
        public List<Categories> ListCategories
        {
            get
            {
                return _categories;
            }
            set
            {
                _categories = value;
                NotifyOfPropertyChange(() => ListCategories);
            }
        }
       
        public Categories ReturnCategories
        {
            get
            {
                return _selectedCategories;
            }
            set
            {
                LoadIndicator = Helper.SwapStatus.swapRun(LoadIndicator);
                _selectedCategories = value;
                NotifyOfPropertyChange(()=>ReturnCategories);
                GetAnnouncing();
                NotifyOfPropertyChange(() => ListAnnouncing);
                LoadIndicator = Helper.SwapStatus.swapRun(LoadIndicator);
                CategoriesGrid = Helper.SwapStatus.swapRun(CategoriesGrid);
                NotifyOfPropertyChange(() => CategoriesGrid);
                AnnouncingGrid = Helper.SwapStatus.swapRun(AnnouncingGrid);
                NotifyOfPropertyChange(() => AnnouncingGrid);
            }
        }
        public bool CategoriesGrid
        {
            get { return _categoriesGrid; }
            set
            {
                _categoriesGrid = value;
                NotifyOfPropertyChange(() => CategoriesGrid);
            }
        }
        public bool AnnouncingGrid
        {
            get { return _announcingGrid; }
            set
            {
                _announcingGrid = value;
                NotifyOfPropertyChange(() => AnnouncingGrid);
            }
        }
        public async void GetAnnouncing()
        {
            _filter.TakeFilter.Category_id = _selectedCategories.Categories_id;
            ListAnnouncing = await QueryList.GetAnnouncingFilter(_filter.TakeFilter);
        }

        public bool LoadIndicator
        {
            get { return _loadIndicator; }
            private set
            {
                _loadIndicator = value;
                NotifyOfPropertyChange(() => LoadIndicator);
            }
        }
        public void GoToFilterView()
        {
            navigationService.UriFor<FilterViewModel>()
                .Navigate();
        }

        protected override async void OnActivate()
        {
            
          LoadIndicator=  Helper.SwapStatus.swapRun(LoadIndicator);
           ListCategories = await QueryList.GetCategories();
           if (_categories != null)
           LoadIndicator =Helper.SwapStatus.swapRun(LoadIndicator);
        }
       
        public  Announcing GoToYourAnnView
        {
            get { return _selectedAnn; }
            set
            {
                _selectedAnn = value;
                GetAnnouncingFull();
                navigationService.UriFor<YourAnnViewModel>()
                    .WithParam(x=>x.Ann_id,_selectedAnn.Announcing_id)
                    .Navigate();
            }
        }

        public async void GetAnnouncingFull()
        {
             _annFull = await QueryList.GetAnnouncingFull(_selectedAnn.Announcing_id.ToString());
        }

    }
    
}
