using Caliburn.Micro;
using Searching.AL.Transport;
using SearchingLibrary;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace Searching.UI.WinClient.ViewModels
{
   public class ProfileViewModel:Screen
    {
        bool _authPanel = true;
        bool _profilePanel = false;
        int user_age=0;
        ITransport transport = new Transport();
        INavigationService navigationService;
       private UserList _user = new UserList();
       private ReturnValue value = new ReturnValue();
        public ProfileViewModel(INavigationService navigationService)
        {
            this.navigationService = navigationService;
            DisplayName = "Профиль";
        }

        public void GoToRegistration()
        {
            navigationService.UriFor<RegistrationViewModel>()
                .Navigate();
        }

        public void GoToPostAnn()
        {
            navigationService.UriFor<PostAnnViewModel>()
                .Navigate();
        }


        public UserList User
        {
            get
            {
                return _user;
            }
            set
            {
                _user = value;
                NotifyOfPropertyChange(() => TakeLogin);
                NotifyOfPropertyChange(() => TakePassword);
                NotifyOfPropertyChange(() => MyLastName);
                NotifyOfPropertyChange(() => MyName);
            }
        }
        public string TakeLogin
        {
            get
            {
                return _user.Mail;
            }
            set
            {
                _user.Mail = value;
                NotifyOfPropertyChange(() => TakeLogin);
                NotifyOfPropertyChange(() => User);
            }
        }
        public string TakePassword
        {
            get
            {
               return _user.Password;
            }
            set
            {
                _user.Password = value;
                NotifyOfPropertyChange(() => TakePassword);
                NotifyOfPropertyChange(() => User);
            }
        }

        public string MyName
        {
            get
            {
                return _user.Name;
            }
            set
            {
                _user.Name = value;
                NotifyOfPropertyChange(() => MyName);
            }
        }
        public string MyLastName
        {
            get
            {
                return _user.LastName;
            }
            set
            {
                _user.LastName = value;
                NotifyOfPropertyChange(() => MyLastName);
            }
        }
        public int MyAge
        {
            get
            {
                return user_age;
            }
            set
            {
                user_age = value;
                NotifyOfPropertyChange(() => MyAge);
            }
        }
        int GetAgeByBirthdate(DateTime DateOfBirth)
        {
            return (int)(DateTime.Now - DateOfBirth).TotalDays / 365;
        }

        public bool AuthPanel
        {
            get
            {
                return _authPanel;
            }
            set
            {
                _authPanel = value;
                NotifyOfPropertyChange(() => AuthPanel);
            }
        }
        public bool ProfilePanel
        {
            get
            {
                return _profilePanel;
            }
            set
            {
                _profilePanel = value;
                NotifyOfPropertyChange(() => ProfilePanel);
            }
        }

        public async void Auth()
      {
            if(User.Mail==null && User.Password == null)
            {
                MessageBox.Show("Введите пожалуйста данные");
            }
                value = await transport.Auth(User);
                if(value.Code==true)
            {
                MessageBox.Show("Вы удачно авторизировались!");
                User = await transport.GetMyUser(User.Mail);
            if (User.Date_Bearthday.HasValue)
                 { 
                DateTime date =DateTime.Parse((User.Date_Bearthday).ToString());
               MyAge= GetAgeByBirthdate(date);
                NotifyOfPropertyChange(() => MyAge);
                 }
                AuthPanel = Helper.SwapStatus.swapVisible(AuthPanel);
                ProfilePanel = Helper.SwapStatus.swapVisible(ProfilePanel);

            }else { MessageBox.Show("Неправильно введенны данные!"); }    
                
        }
        public void Exit()
        {
            AuthPanel = Helper.SwapStatus.swapVisible(AuthPanel);
            ProfilePanel = Helper.SwapStatus.swapVisible(ProfilePanel);
        }

        }
    }

