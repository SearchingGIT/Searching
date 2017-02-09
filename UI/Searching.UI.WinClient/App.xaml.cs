using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Navigation;
using System.Windows.Shapes;
using Microsoft.Phone.Controls;
using Microsoft.Phone.Shell;
using Telerik.Windows.Controls;
using Searching.UI.WinClient.ViewModels;

namespace Searching.UI.WinClient
{
    public partial class App : Application
    {
        public App()
        {
            try {
                InitializeComponent();
            }
            catch(Exception ex)
            {
                throw ex;
            }
        }
    }
}
