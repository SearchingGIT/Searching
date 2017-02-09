using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Activities;

namespace WorkflowService2
{

    public sealed class GetNewsActivity : CodeActivity
    {
       public OutArgument<List<Searching.BE.WF.NotificationService.ApiService.Messages>> msgList { get; set; }
        protected override void Execute(CodeActivityContext context) {
            
            context.SetValue(msgList, WorkflowService3.DB.GetNewsMessages());
        }
    }
}
