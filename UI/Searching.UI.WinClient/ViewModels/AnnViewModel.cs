using SearchingLibrary;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Searching.UI.WinClient.ViewModels
{
   public class AnnouncingViewModel: INotifyPropertyChanged
    {
        private List<Announcing> _ann;
        public AnnouncingViewModel()
        {
            _ann = new List<Announcing>();
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
                NotifyPropertyChanged("Ann");
            }
        }
        public event PropertyChangedEventHandler PropertyChanged;
        private void NotifyPropertyChanged(String propertyName)
        {
            PropertyChangedEventHandler handler = PropertyChanged;
            if (null != handler)
            {
                handler(this, new PropertyChangedEventArgs(propertyName));
            }
        }
    }
}
