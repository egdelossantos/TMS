using System.Collections.Generic;

namespace TerritoryManagementSystem.Models
{
    public class ActionBarModel
    {
        public ActionBarModel(string title, string cancel = "")
        {
            ShowCancel = !string.IsNullOrEmpty(cancel);
            CancelHref = cancel;
            Title = title;
            CreateHref = string.Empty;            
            CustomButtons = new List<CustomToolBarButton>();
        }

        public string CancelHref { get; set; }
        public string CreateHref { get; set; }
        public List<CustomToolBarButton> CustomButtons { get; set; }

        public bool ShowCancel { get; set; }
        public bool ShowSaveContinue { get; set; }
        public bool ShowSave { get; set; }
        public bool ShowSaveExit { get; set; }
        public string SaveExitClick { get; set; }        

        public bool ShowBackward { get; set; }
        public bool ShowForward { get; set; }
        
        public bool ShowCreate { get; set; }
        public bool ShowDelete { get; set; }

        public bool ShowExport { get; set; }        
        public bool ShowImport { get; set; }
        public bool ShowLaunch { get; set; }
        public bool ShowPrinter { get; set; }

        public string Title { get; set; }

        public class CustomToolBarButton
        {
            public CustomToolBarButton()
            {
            }

            public CustomToolBarButton(string title, string spanClass, string onClickJavascript)
            {
                Title = title;
                SpanClass = spanClass;
                OnClickJavascript = onClickJavascript;
            }

            public string ButtonId { get; set; }
            public string Href { get; set; }
            public string SpanClass { get; set; }
            public string Title { get; set; }
            public string OnClickJavascript { get; set; }
        }
    }
}