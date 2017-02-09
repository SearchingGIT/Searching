using Caliburn.Micro;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Searching.UI.WinClient.Helper
{
   public  class SwapStatus: PropertyChangedBase
    {
        public static bool swapVisible(bool status)
        {
            if (status == true) status = false;
            else status = true;
            return status;
        }
    }
}
