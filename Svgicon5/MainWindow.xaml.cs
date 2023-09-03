using Microsoft.UI;
using Microsoft.UI.Windowing;
using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;
using Microsoft.UI.Xaml.Media.Imaging;
using Svg;
using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using Windows.Graphics;
using Windows.Storage;
using Windows.Storage.Pickers;
using WinRT.Interop;

namespace Svgicon5
{
    public sealed partial class MainWindow : Window
    {
        StorageFile file = null!;
        SvgDocument svgDocument = null!;
        string[] imgPaths = {};
        int[] iconSizes = {};


        public MainWindow()
        {
            InitializeComponent();
            ExtendsContentIntoTitleBar = true;
            SetTitleBar(AppTitleBar);
            setWindowSize(1200, 800);
        }

        void setWindowSize(int width, int height)
        {
            IntPtr hWnd = WindowNative.GetWindowHandle(this);
            WindowId myWndId = Win32Interop.GetWindowIdFromWindow(hWnd);
            AppWindow appWindow = AppWindow.GetFromWindowId(myWndId);
            appWindow.Resize(new SizeInt32(width, height));
        }

        async void Open(object sender, RoutedEventArgs e)
        {
            IntPtr hwnd = WindowNative.GetWindowHandle(this);
            FileOpenPicker picker = new()
            {
                ViewMode = PickerViewMode.Thumbnail
            };
            picker.FileTypeFilter.Add(".svg");
            InitializeWithWindow.Initialize(picker, hwnd);
            file = await picker.PickSingleFileAsync();
            if (file == null)
                return;

            svgDocument = SvgDocument.Open(file.Path);
            string tmp = Path.GetTempPath();
            int s = 2048;
            string tmpImage = $"{tmp}\\svgicon5-{s}.png";
            svgDocument.Width = new SvgUnit(SvgUnitType.Pixel, s);
            svgDocument.Height = new SvgUnit(SvgUnitType.Pixel, s);
            Bitmap bitmap = svgDocument.Draw();
            bitmap.Save(tmpImage, ImageFormat.Png);
            iconImage.Source = new BitmapImage(new Uri(tmpImage));

            generateButton.IsEnabled = true;
        }

        void Exit(object sender, RoutedEventArgs e)
        {
            Close();
        }

        void GenerateButton(object sender, RoutedEventArgs e)
        {
            int[] sizes = new int[] { 16, 20, 24, 32, 40, 48, 64, 256, 30, 36, 60, 72, 80, 96 };
            imgPaths = new string[] { };
            iconSizes = new int[] { };

            string fileNameWithOutExtension = Path.GetFileNameWithoutExtension(file.Path);
            Bitmap bitmap;
            string saveDir = Path.GetDirectoryName(file.Path)!;

            // 保存先
            string[] pngs = {};

            foreach (int size in sizes)
            {
                CheckBox? checkBox = IconSize.FindName($"size{size}") as CheckBox;
                if (checkBox == null) continue;
                if ((bool)checkBox!.IsChecked!)
                {
                    svgDocument.Width = new SvgUnit(SvgUnitType.Pixel, size);
                    svgDocument.Height = new SvgUnit(SvgUnitType.Pixel, size);
                    bitmap = svgDocument.Draw();
                    string imgFile = $"{saveDir}\\{fileNameWithOutExtension}-{size}.png";
                    Array.Resize(ref pngs, pngs.Length + 1);
                    pngs[pngs.Length - 1] = imgFile;
                    iconSizes.Append(size);
                    imgPaths.Append(imgFile);
                    bitmap.Save(imgFile, ImageFormat.Png);
                    bitmap.Dispose();
                }
            }

            PNG2ICO png2ico = new(pngs, saveDir!, file.Path);

            _ = Dialog.CreateDialog(this, "保存しました", $"{png2ico.icoPath} へ保存しました。");
        }

        void ClickAbout(object sender, RoutedEventArgs e)
        {
            _ = Dialog.CreateDialog(this, "SVG2ICO", "© 2023 ひかり");
        }
    }
}
