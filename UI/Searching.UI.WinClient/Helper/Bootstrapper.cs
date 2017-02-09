using Caliburn.Micro;
using Microsoft.Phone.Controls;
using Searching.UI.WinClient.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using Telerik.Windows.Controls;
using Microsoft.Phone.Shell;
using System.ComponentModel;
using Caliburn.Micro.BindableAppBar;
using System.Windows.Controls;
using Searching.AL.Transport;

namespace Searching.UI.WinClient.Helper
{
    public class Bootstrapper : PhoneBootstrapperBase
    {

        private PhoneContainer container;
        private ITransport transport= new Transport();

        private PhoneApplicationFrame rootFrame;
        private new PhoneApplicationFrame RootFrame
        {
            get
            {
                if (this.rootFrame == null)
                {
                    this.rootFrame = new RadPhoneApplicationFrame();
                }
                return this.rootFrame;
            }
            set
            {
                this.rootFrame = value;
            }
        }
        
        public Bootstrapper()
        {
            Initialize();
        }
        protected override void Configure()
        {
            try
            { 
            transport.CheckExistBD();
            }
            catch(Exception ex)
            {
                throw ex;
            }
            container = new PhoneContainer();
            container.RegisterPhoneServices(RootFrame);
            container.PerRequest<SearchingViewModel>();
            container.PerRequest<AnnouncingViewModel>();
            container.PerRequest<ProfileViewModel>();
            container.PerRequest<FilterViewModel>();
            container.PerRequest<YourAnnViewModel>();
            container.PerRequest<RegistrationViewModel>();
            container.PerRequest<PostAnnViewModel>();
            
                AddCustomConventions();
        }

        protected override object GetInstance(Type service, string key)
        {
            return container.GetInstance(service, key);
        }

        protected override IEnumerable<object> GetAllInstances(Type service)
        {
            return container.GetAllInstances(service);
        }

        protected override void BuildUp(object instance)
        {
            container.BuildUp(instance);
        }

        public static void AddCustomConventions()
        {
            ConventionManager.AddElementConvention<RadDataBoundListBox>(RadDataBoundListBox.ItemsSourceProperty, "ListCategories", "Loaded");
            ConventionManager.AddElementConvention<RadDataBoundListBox>(RadDataBoundListBox.SelectedItemProperty, "SelectedCategories", "ItemTap");
            ConventionManager.AddElementConvention<RadBusyIndicator>(RadBusyIndicator.IsRunningProperty, "LoadIndicator", "Loaded");
            ConventionManager.AddElementConvention<RadDataBoundListBox>(RadDataBoundListBox.ItemsSourceProperty, "ListAnnouncing", "Loaded");
            ConventionManager.AddElementConvention<RadDataBoundListBox>(RadDataBoundListBox.SelectedItemProperty, "SelectedAnnouncing", "ItemTap");
            ConventionManager.AddElementConvention<RadTextBox>(RadTextBox.TextProperty, "TakeMail", "TextChanged");
            ConventionManager.AddElementConvention<RadPasswordBox>(RadPasswordBox.PasswordProperty, "TakePass", "TextChanged");
            ConventionManager.AddElementConvention<RadPasswordBox>(RadPasswordBox.PasswordProperty, "CheckPass", "TextChanged");
            ConventionManager.AddElementConvention<RadTextBox>(RadTextBox.TextProperty, "TakeName", "TextChanged");
            ConventionManager.AddElementConvention<RadTextBox>(RadTextBox.TextProperty, "TakeLastName", "TextChanged");
            ConventionManager.AddElementConvention<RadTextBox>(RadTextBox.TextProperty, "TakeLogin", "TextChanged");
            ConventionManager.AddElementConvention<RadPasswordBox>(RadPasswordBox.PasswordProperty, "TakePassword", "TextChanged");
            ConventionManager.AddElementConvention<BindableAppBarButton>(Control.IsEnabledProperty, "DataContext", "Click");
            ConventionManager.AddElementConvention<RadTextBox>(RadTextBox.TextProperty, "TakeNameAnn", "TextChanged");
            ConventionManager.AddElementConvention<RadTextBox>(RadTextBox.TextProperty, "TakeInfoAnn", "TextChanged");
            ConventionManager.AddElementConvention<BindableAppBarButton>(Control.IsEnabledProperty, "PostAnn", "Click");
        }

        protected override PhoneApplicationFrame CreatePhoneApplicationFrame()
        {
            return  RootFrame;
        }
        protected override void OnClose(object sender, ClosingEventArgs e)
        {
            base.OnClose(sender, e);
        }
       
        public void OnGoBack(CancelEventArgs eventArgs)
        {

        }
    }
}
