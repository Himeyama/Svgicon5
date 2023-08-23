using Microsoft.UI.Xaml.Controls;
using System;
using System.Threading.Tasks;

namespace Svgicon5
{
    public sealed partial class Dialog : Page
    {
        public Dialog()
        {
            InitializeComponent();
        }

        public static async Task CreateDialog(MainWindow mainWindow, string title, string contentText)
        {
            ContentDialog dialog = new();
            dialog.XamlRoot = mainWindow.Content.XamlRoot;
            dialog.Title = title;
            dialog.PrimaryButtonText = "OK";
            dialog.DefaultButton = ContentDialogButton.Primary;
            Dialog content = new();
            dialog.Content = content;
            content.dialogText.Text = contentText;
            await dialog.ShowAsync();
        }
    }
}
