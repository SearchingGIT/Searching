﻿#pragma checksum "C:\Repository\projects\Searching\Sourse Code\Searching.Solution\UI\Searching.UI.WinClient\Views\ProfileView.xaml" "{406ea660-64cf-4c82-b6f0-42d48172a799}" "B137889F2BDF071AC7B812D36A6B435E"
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
    
    
    public partial class ProfileView : Microsoft.Phone.Controls.PhoneApplicationPage {
        
        internal System.Windows.Controls.StackPanel AuthPanel;
        
        internal Telerik.Windows.Controls.RadTextBox TakeLogin;
        
        internal Telerik.Windows.Controls.RadPasswordBox TakePassword;
        
        internal System.Windows.Controls.Button Auth;
        
        internal System.Windows.Controls.HyperlinkButton GoToRegistration;
        
        internal System.Windows.Controls.StackPanel ProfilePanel;
        
        internal System.Windows.Controls.Button button2;
        
        internal System.Windows.Controls.Button GoToPostAnn;
        
        internal System.Windows.Controls.Button Exit;
        
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
            System.Windows.Application.LoadComponent(this, new System.Uri("/Searching.UI.WinClient;component/Views/ProfileView.xaml", System.UriKind.Relative));
            this.AuthPanel = ((System.Windows.Controls.StackPanel)(this.FindName("AuthPanel")));
            this.TakeLogin = ((Telerik.Windows.Controls.RadTextBox)(this.FindName("TakeLogin")));
            this.TakePassword = ((Telerik.Windows.Controls.RadPasswordBox)(this.FindName("TakePassword")));
            this.Auth = ((System.Windows.Controls.Button)(this.FindName("Auth")));
            this.GoToRegistration = ((System.Windows.Controls.HyperlinkButton)(this.FindName("GoToRegistration")));
            this.ProfilePanel = ((System.Windows.Controls.StackPanel)(this.FindName("ProfilePanel")));
            this.button2 = ((System.Windows.Controls.Button)(this.FindName("button2")));
            this.GoToPostAnn = ((System.Windows.Controls.Button)(this.FindName("GoToPostAnn")));
            this.Exit = ((System.Windows.Controls.Button)(this.FindName("Exit")));
        }
    }
}

