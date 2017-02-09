using Caliburn.Micro;
using Searching.AL.Transport;
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
    //View Model страницы выбора Категорий и объявлений
    public class AnnouncingViewModel : Screen
    {
        private readonly INavigationService navigationService;
        private bool _categoriesGrid=true;
        private bool _announcingGrid = false;
        //Список категорий
        private List<Categories> _categories;
        //Список объявлений
        private List<Announcing> _ann= new List<Announcing>();
        //Выбранная категория  
        private Categories _selectedCategories=new Categories();
        private bool _loadIndicator;
        //Выбранное объявления
        public Announcing _selectedAnn=new Announcing();
        public Announcing _annFull= new Announcing();
        FilterViewModel _filter = new FilterViewModel();
        private ITransport transport= new Transport();
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
                if(_selectedCategories==null)
                {
                    _selectedCategories = new Categories();
                }
                return _selectedCategories;
            }
            set
            {
                _selectedCategories = value;
                NotifyOfPropertyChange(()=>ReturnCategories);
            }
        }

        public bool CategoriesGrid
        {
            get
            {
                return _categoriesGrid;
            }
            set
            {
                _categoriesGrid = value;
                NotifyOfPropertyChange(() => CategoriesGrid);
            }
        }
        public bool AnnouncingGrid
        {
            get
            {
                return _announcingGrid;
            }
            set
            {
                _announcingGrid = value;
                NotifyOfPropertyChange(() => AnnouncingGrid);
            }
        }
        //Вызов выбранной Категории.По нажатию
        public async void SelectedCategories(Categories SelectedItem)
        {
            LoadIndicator = Helper.SwapStatus.swapVisible(LoadIndicator);
            _filter.TakeFilter.Category_id = SelectedItem.Categories_id;
            ListAnnouncing = await transport.GetAnnouncing(_filter.TakeFilter);
            NotifyOfPropertyChange(() => ListAnnouncing);
            CategoriesGrid = Helper.SwapStatus.swapVisible(CategoriesGrid);
            NotifyOfPropertyChange(() => CategoriesGrid);
            AnnouncingGrid = Helper.SwapStatus.swapVisible(AnnouncingGrid);
            NotifyOfPropertyChange(() => AnnouncingGrid);
            LoadIndicator = Helper.SwapStatus.swapVisible(LoadIndicator);
        }
       
        public bool LoadIndicator
        {
            get
            {
                return _loadIndicator;
            }
             set
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
            
            SelectedAnn = new Announcing();
            NotifyOfPropertyChange(() => SelectedAnn);
            ReturnCategories = new Categories();
            NotifyOfPropertyChange(() => ReturnCategories);
            if(ListCategories!=null)
            {
                return;
            }
          LoadIndicator=  Helper.SwapStatus.swapVisible(LoadIndicator);
            ListCategories = await transport.GetCategories();
           if (_categories != null)
           LoadIndicator =Helper.SwapStatus.swapVisible(LoadIndicator);
        }
       
        public  Announcing SelectedAnn
        {
            get
            {
                if(_selectedAnn==null)
                { _selectedAnn = new Announcing(); }
                return _selectedAnn;
            }
            set
            {
                _selectedAnn = value;
                NotifyOfPropertyChange(() => SelectedAnn);
            }
        }
        //Выбранное объявление по нажатию.
        public void SelectedAnnouncing(Announcing SelectedItem)
        {
            SelectedAnn = SelectedItem;
            if (SelectedAnn == null) return;
            navigationService.UriFor<YourAnnViewModel>()
                .WithParam(x => x.Ann_id, SelectedAnn.Announcing_id)
                .Navigate();
            SelectedItem = new Announcing();
        }
    }   
}
