//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Searching.Shared.API.DataModel
{
    using System;
    using System.Collections.Generic;
    using System.Runtime.Serialization;


    [DataContract]
    public partial class Announcing
    {
        [DataMember]
        public string UserName { get; set; }
        [DataMember]
        public string UserLastName { get; set; }
        [DataMember]
        public string CityName { get; set;}
        [DataMember]
        public int? Id { get; set; }
        [DataMember]
        public string Name { get; set; }
        [DataMember]
        public int? Phone { get; set; }
        [IgnoreDataMember]
        public System.DateTime? Date { get; set; }
        [DataMember]
        public string JsonDate { get; set; }
        [DataMember]
        public string Info { get; set; }
        [DataMember]
        public int? CategoryId { get; set; }
        [DataMember]
        public int? CityId { get; set; }
        [DataMember]
        public int? UserId { get; set; }
        [DataMember]
        public int? AreaId { get; set; }
    }
}
