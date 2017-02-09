using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Caliburn.Micro;
using SearchingLibrary;
using System.Windows;
using Searching.AL.Transport;

namespace Searching.UI.WinClient.ViewModels
{
    public class RegistrationViewModel : PropertyChangedBase
    {
        bool _error = false;
        ITransport transport = new Transport();
        private UserList _user;
        private string _chekPass="";
        private ReturnValue result = new ReturnValue();
        public RegistrationViewModel()
        {
            _user = new UserList();
        }

        public UserList TakeUser
        {
            get
            {
                return _user;
            }
            set
            {
                _user = value;
                NotifyOfPropertyChange(() => TakeLastName);
                NotifyOfPropertyChange(() => TakeMail);
                NotifyOfPropertyChange(() => TakeName);
                NotifyOfPropertyChange(() => TakeLastName);
            }
        }
        public string TakeMail
        {
            get
            {
                return _user.Mail;
            }
            set
            {
                _user.Mail = value;
                NotifyOfPropertyChange(() => TakeMail);
            }
        }
        public string TakePass
        {
            get
            {
                return _user.Password;
            }
            set
            {
                _user.Password = value;
                NotifyOfPropertyChange(() => TakePass);
            }
        }
        public string CheckPass
        {
            get
            {
                return _chekPass;
            }
            set
            {
                _chekPass = value;
                NotifyOfPropertyChange(() => CheckPass);
            }
        }
        public string TakeName
        {
            get
            {
                return _user.Name;
            }
            set
            {
                _user.Name = value;
            }
        }
        public string TakeLastName
        {
            get
            {
                return _user.LastName;
            }
            set
            {
                _user.LastName = value;
                NotifyOfPropertyChange(() => TakeLastName);
            }
        }
        public bool Error
        {
            get
            {
                return _error;
            }
            set
            {
                _error = value;
                NotifyOfPropertyChange(() => Error);
            }
        }

        public  async void Registration()
        {
            Error = Helper.SwapStatus.swapVisible(Error);
            TakeUser.Type_login = 1;
            if (TakePass != CheckPass)
            {
                
                return;
            }

            result = await transport.Registration(TakeUser);
            if (result.Code==true)
            { 
                MessageBox.Show(result.Message);
            }else
            {
                MessageBox.Show("Регистрация неудалась. Попробуйте еще раз");
            }
        }
    }
}
