using Caliburn.Micro;
using Searching.AL.Transport;
using SearchingLibrary;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Searching.UI.WinClient.ViewModels
{
   public class YourAnnViewModel:Screen
    {
        ITransport transport = new Transport();
        private readonly INavigationService navigationService;
        public Announcing _ann;
        public YourAnnViewModel(INavigationService navigationService)
        {
            _ann = new Announcing();
            this.navigationService = navigationService;
        }
        public Announcing TakeAnn
        {
            get
            {
                return _ann;
            }
            set
            {
                _ann =value;
                NotifyOfPropertyChange(() => TakeAnn);
                NotifyOfPropertyChange(() => NameAnn);
                NotifyOfPropertyChange(() => InfoAnn);
                NotifyOfPropertyChange(() => TakeName);
                NotifyOfPropertyChange(() => TakeLastName);
            }
        }
        public string NameAnn
        {
            get
            {
                return _ann.Name_Announcing;
            }
            set
            {
                _ann.Name_Announcing = value;
                NotifyOfPropertyChange(() => NameAnn);
            }
        }
        public string InfoAnn
        {
            get
            {
                return _ann.Info_Announcing;
            }
            set
            {
                _ann.Info_Announcing = value;
                NotifyOfPropertyChange(() => InfoAnn);
            }
        }
        public string TakeName
        {
            get
            {
                return _ann.UserName;
            }
            set
            {
                _ann.UserName = value;
                NotifyOfPropertyChange(() => TakeName);

            }
        }

        public string TakeLastName
        {
            get
            {
                return _ann.UserLastName;
            }
            set
            {
                _ann.UserLastName = value;
                NotifyOfPropertyChange(() => TakeLastName);
            }
        }
        public int? Ann_id
        {
            get
            {
                return _ann.Announcing_id;
            }
            set
            {
                _ann.Announcing_id = value;
                NotifyOfPropertyChange(() => Ann_id);
            }
        }
        
        protected override async void OnActivate()
        {
            TakeAnn = await transport.GetAnnouncingFull(_ann.Announcing_id.ToString());
            
        }
        protected override void OnDeactivate(bool close)
        {
            base.OnDeactivate(close);
        }
        public void OnBackKeyPress(CancelEventArgs eventArgs)
        {
            navigationService.UriFor<AnnouncingViewModel>()
                .Navigate();
        }
    }
}
