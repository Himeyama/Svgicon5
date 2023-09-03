using System.Drawing;
namespace Svgicon5;

public class PNG2ICO
{
    public string icoPath {get; set;} = "";

    byte[] ConvertPngToByteArray(string filePath)
    {
        byte[] bytes = File.ReadAllBytes(filePath);
        return bytes;
    }

    void GetImageSize(string filePath, out int width, out int height)
    {
        Image image = Image.FromFile(filePath);
        width = image.Width;
        height = image.Height;
        image.Dispose();
    }

    string ConvertByteArrayToHexString(byte[] byteArray)
    {
        string hexString = BitConverter.ToString(byteArray).Replace("-", "");
        return hexString;
    }

    public PNG2ICO(string[] pngs, string dir, string filePath)
    {
        int n_pngs = pngs.Length;
        byte[] dat = new byte[] { 0x00, 0x00, 0x01, 0x00, (byte)n_pngs, 0x00 };
        long offset = 6 + n_pngs * 16;
        string basename = Path.GetFileNameWithoutExtension(filePath);

        foreach (string png in pngs)
        {
            int width = 0, height = 0;
            GetImageSize(png, out width, out height);
            byte[] info = new byte[] { (byte)width, (byte)height, 0, 0, 1, 0, 32, 0 };
            dat = dat.Concat(info).ToArray();

            FileInfo fileInfo = new FileInfo(png);
            long byteSize = fileInfo.Length;
            byte[] bByteSize = BitConverter.GetBytes(byteSize);
            dat = dat.Concat(bByteSize.Take(4)).ToArray();

            byte[] bOffset = BitConverter.GetBytes(offset);
            dat = dat.Concat(bOffset.Take(4)).ToArray();

            offset += byteSize;
        }

        foreach (string png in pngs)
        {
            byte[] img_bytes = ConvertPngToByteArray(png);
            dat = dat.Concat(img_bytes).ToArray();
        }

        icoPath = $"{dir}\\{basename}.ico";
        File.WriteAllBytes(icoPath, dat);

        foreach (string imgFile in pngs)
        {
            if (File.Exists(imgFile))
            {
                try{
                    File.Delete(imgFile);
                }catch{
                    ;
                }
            }
        }
    }
}
