using Caliburn.Micro;
using SearchingLibrary;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Searching.UI.WinClient.ViewModels
{
    public class FilterViewModel: PropertyChangedBase
    {
        private AnnFilter _filter;
        private List<Country> _country;
        private List<AreasOfCity> _areas;
        private List<Cities> _cities;
       public FilterViewModel()
        {
            _filter = new AnnFilter();
        }
        public  AnnFilter TakeFilter
        {
            get
            {
                return _filter;
            }
            set
            {
                _filter = value;
                
            }
        }

       
    }
}
