﻿#pragma checksum "C:\Repository\projects\Searching\Sourse Code\Searching.Solution\UI\Searching.UI.WinClient\Views\AnnouncingView.xaml" "{406ea660-64cf-4c82-b6f0-42d48172a799}" "C5CBC43FB7E92A4E4238123E718FD319"
//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.42000
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

using Microsoft.Phone.Controls;
using System;
using System.Windows;
using System.Windows.Automation;
using System.Windows.Automation.Peers;
using System.Windows.Automation.Provider;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Interop;
using System.Windows.Markup;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Media.Imaging;
using System.Windows.Resources;
using System.Windows.Shapes;
using System.Windows.Threading;
using Telerik.Windows.Controls;


namespace Searching.UI.WinClient.Views {
    
    
    public partial class AnnouncingView : Microsoft.Phone.Controls.PhoneApplicationPage {
        
        internal System.Windows.Controls.Grid LayoutRoot;
        
        internal System.Windows.Controls.Grid CateglistGrid;
        
        internal System.Windows.DataTemplate AnnouncingTemplate;
        
        internal System.Windows.Controls.StackPanel CategoriesPanel;
        
        internal System.Windows.Controls.Grid CategoriesGrid;
        
        internal Telerik.Windows.Controls.RadTextBox radTextBox1;
        
        internal System.Windows.Controls.Button GoToFilterView;
        
        internal Telerik.Windows.Controls.RadBusyIndicator LoadIndicator;
        
        internal System.Windows.Controls.Grid AnnouncingGrid;
        
        private bool _contentLoaded;
        
        /// <summary>
        /// InitializeComponent
        /// </summary>
        [System.Diagnostics.DebuggerNonUserCodeAttribute()]
        public void InitializeComponent() {
            if (_contentLoaded) {
                return;
            }
            _contentLoaded = true;
            System.Windows.Application.LoadComponent(this, new System.Uri("/Searching.UI.WinClient;component/Views/AnnouncingView.xaml", System.UriKind.Relative));
            this.LayoutRoot = ((System.Windows.Controls.Grid)(this.FindName("LayoutRoot")));
            this.CateglistGrid = ((System.Windows.Controls.Grid)(this.FindName("CateglistGrid")));
            this.AnnouncingTemplate = ((System.Windows.DataTemplate)(this.FindName("AnnouncingTemplate")));
            this.CategoriesPanel = ((System.Windows.Controls.StackPanel)(this.FindName("CategoriesPanel")));
            this.CategoriesGrid = ((System.Windows.Controls.Grid)(this.FindName("CategoriesGrid")));
            this.radTextBox1 = ((Telerik.Windows.Controls.RadTextBox)(this.FindName("radTextBox1")));
            this.GoToFilterView = ((System.Windows.Controls.Button)(this.FindName("GoToFilterView")));
            this.LoadIndicator = ((Telerik.Windows.Controls.RadBusyIndicator)(this.FindName("LoadIndicator")));
            this.AnnouncingGrid = ((System.Windows.Controls.Grid)(this.FindName("AnnouncingGrid")));
        }
    }
}

