

namespace Searching.Shared.API.DataModel
{
    using System;
    using System.Collections.Generic;
    using System.Runtime.Serialization;

    [DataContract]
  public class AnnouncingFilter
    {
        [DataMember]
        public int? CategoryId { get; set; }
        [DataMember]
        public int? CountryId { get; set; }
        [DataMember]
        public int? CityId { get; set; }
        [DataMember]
        public int? AreaId { get; set; }
        [DataMember]
        public char? UserGender { get; set; }
        [IgnoreDataMember]
        public DateTime? AnnouncingDate { get; set; }
        [DataMember]
        public string JsonAnnouncingDate { get; set;}
        [IgnoreDataMember]
        public DateTime? MinDateBirthday { get; set; }
        [DataMember]
        public string JsonMinDateBirthday { get; set; }
        [IgnoreDataMember]
        public DateTime? MaxDateBirthday { get; set; }
        [DataMember]
        public string JsonMaxDateBirthday { get; set; }
        [DataMember]
        public bool? Popular { get; set; }
        [DataMember]
        public bool? DateSort { get; set; }
        [DataMember]
        public int NPage { get; set; }
        [DataMember]
        public int SizePage { get; set; }
    }
}