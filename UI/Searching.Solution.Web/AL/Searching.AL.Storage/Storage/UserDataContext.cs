using Searching.AL.Storage.Model;
using System;
using System.Collections.Generic;
using System.Data.Linq;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Searching.AL.Storage
{
   public  class UserDataContext:DataContext
    {
        public static string DBConnectionString = @"isostore:/Databases.sdf";
        public UserDataContext(string connectrionString):base(connectrionString)
        {
            
        }
        public Table<LUsers> Users
        {
            get { return this.GetTable<LUsers>(); }
        }
        public Table<LCategories>Categories
        {
            get { return this.GetTable<LCategories>(); }
        }
        public Table<LCountries> Countries
        {
            get { return this.GetTable<LCountries>(); }
        }
        public Table<LCities> Cities
        {
            get { return this.GetTable<LCities>(); }
        }
        public Table<LAreas> Areas
        {
            get { return this.GetTable<LAreas>(); }
        }
        public Table<LFavoriteAnn> FavoriteAnn
        {
            get
            { return this.GetTable<LFavoriteAnn>(); }
        }
        public Table<LSelectedAnn> SelectedAnn
        {
            get { return this.GetTable<LSelectedAnn>(); }
        }
        public Table<LAnnouncing> Ann
        {
            get { return this.GetTable<LAnnouncing>(); }
        }
    }
}
