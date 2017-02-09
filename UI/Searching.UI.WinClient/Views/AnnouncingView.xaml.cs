using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Net;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Navigation;
using Microsoft.Phone.Controls;
using Microsoft.Phone.Shell;

namespace Searching.UI.WinClient.Views
{
    public partial class AnnouncingView : PhoneApplicationPage
    {
        public AnnouncingView()
        {
            InitializeComponent();
        }

        
        protected override void OnBackKeyPress(CancelEventArgs e)
        {
            e.Cancel = true;
        }

        private void PhoneApplicationPage_BackKeyPress(object sender, CancelEventArgs e)
        {

        }
    }
}