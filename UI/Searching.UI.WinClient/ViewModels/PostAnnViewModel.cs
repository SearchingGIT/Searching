using Caliburn.Micro;
using Searching.AL.Transport.Logic.Transport;
using SearchingLibrary;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace Searching.UI.WinClient.ViewModels
{
   public class PostAnnViewModel:PropertyChangedBase
    {
        Announcing ann;

        public PostAnnViewModel()
        {
            ann = new Announcing();
            ann.User_id = 1;
            ann.Categories_id = 2;
        }

        public string TakeNameAnn
        {
            get
            {
                return ann.Name_Announcing;
            }
            set
            {
                ann.Name_Announcing = value;
                NotifyOfPropertyChange(() => TakeNameAnn);
            }
        }
        public string TakeInfoAnn
        {
            get
            {
                return ann.Info_Announcing;
            }set
            {
                ann.Info_Announcing = value;
                NotifyOfPropertyChange(() => TakeInfoAnn);
            }
        }
        public async void PostAnn()
        {
            ReturnValue result = new ReturnValue();
            if(ann.Name_Announcing==null && ann.Info_Announcing == null)
            {
                MessageBox.Show("Заполните все поля!");
            } else
            {
                result = await QueryList.PostAnn(ann);
                if (result.Code==true)
                {
                    MessageBox.Show("Объявление успешно добавлено!");
                }else
                {
                    MessageBox.Show("Произошла  ошибка! Попробуйте еще раз");
                }
            }
        }
    }
}
