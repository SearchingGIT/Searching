using Caliburn.Micro;
using Searching.UI.WinClient.Helper;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Searching.UI.WinClient.ViewModels
{
   public class SearchingViewModel:Conductor<IScreen>.Collection.OneActive 
    {
        private  AnnouncingViewModel announcing;
        private readonly ProfileViewModel profile;
        
        public SearchingViewModel(AnnouncingViewModel announcing, ProfileViewModel profile)
        {
            this.announcing = announcing;
            this.profile = profile;
        }
        protected override void OnInitialize()
        {
            base.OnInitialize();
            Items.Add(announcing);
            Items.Add(profile);
            ActivateItem(announcing);
        }
        protected override void OnDeactivate(bool close)
        {
            base.OnDeactivate(close);
        
        }
        public void OnBackKeyPress(CancelEventArgs eventArgs)
        {
            eventArgs.Cancel = true;
            

                if (announcing.CategoriesGrid == true) { 
                    eventArgs.Cancel = false;
            
            }
            if (announcing.AnnouncingGrid == true)
                {
                    announcing.AnnouncingGrid = false;
                    announcing.CategoriesGrid = true;
                
            }
            
            
        }
    }
}
