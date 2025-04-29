using System.Security.Cryptography;
using System.Text;

namespace ApiViajes.Helpers
{
    public class HelperCryptography
    {
        private static string salt;
        private static int iterate;
        private static string key;
        public static void Initialize(string saltValue, string iterateValue, string keyValue)
        {
            salt = saltValue;
            iterate = int.Parse(iterateValue);
            key = keyValue;
        }

        public static string EncryptString(String dato)
        {
            byte[] saltpassword = EncriptarPasswordSalt(key, salt, iterate);
            String res = EncryptString(saltpassword, dato);
            return res;
        }

        public static string DecryptString(String dato)
        {
            byte[] saltpassword = EncriptarPasswordSalt(key, salt, iterate);
            String res = DecryptString(saltpassword, dato);
            return res;
        }

        private static string EncryptString(byte[] key, string plainText)
        {
            byte[] iv = new byte[16];
            byte[] array;

            using (Aes aes = Aes.Create())
            {
                aes.Key = key;
                aes.IV = iv;

                ICryptoTransform encryptor = aes.CreateEncryptor(aes.Key, aes.IV);

                using (MemoryStream memoryStream = new MemoryStream())
                {
                    using (CryptoStream cryptoStream = new CryptoStream((Stream)memoryStream, encryptor, CryptoStreamMode.Write))
                    {
                        using (StreamWriter streamWriter = new StreamWriter((Stream)cryptoStream))
                        {
                            streamWriter.Write(plainText);
                        }

                        array = memoryStream.ToArray();
                    }
                }
            }

            return Convert.ToBase64String(array);
        }

        private static byte[] EncriptarPasswordSalt(string contenido
            , string salt, int numhash)
        {
            //REALIZAMOS LA COMBINACION DE ENCRIPTADO
            //CON SU SALT
            string textocompleto = contenido + salt;
            //DECLARAMOS EL OBJETO SHA256
            //SHA256Managed objsha = new SHA256Managed();
            SHA256 objsha = SHA256.Create();
            byte[] bytesalida = null;

            try
            {
                //CONVERTIMOS EL TEXTO A BYTES
                bytesalida =
                    Encoding.UTF8.GetBytes(textocompleto);
                //Convert.FromBase64String(textocompleto);
                //ENCRIPTAMOS EL TEXTO 1000 VECES
                for (int i = 0; i < numhash; i++)
                    bytesalida = objsha.ComputeHash(bytesalida);
            }
            finally
            {
                objsha.Clear();
            }
            //DEVOLVEMOS LOS BYTES DE SALIDA
            return bytesalida;
        }

        private static string DecryptString(byte[] key, string cipherText)
        {
            byte[] iv = new byte[16];
            byte[] buffer = Convert.FromBase64String(cipherText);

            using (Aes aes = Aes.Create())
            {
                aes.Key = key;
                aes.IV = iv;
                ICryptoTransform decryptor = aes.CreateDecryptor(aes.Key, aes.IV);

                using (MemoryStream memoryStream = new MemoryStream(buffer))
                {
                    using (CryptoStream cryptoStream = new CryptoStream((Stream)memoryStream, decryptor, CryptoStreamMode.Read))
                    {
                        using (StreamReader streamReader = new StreamReader((Stream)cryptoStream))
                        {
                            return streamReader.ReadToEnd();
                        }
                    }
                }
            }
        }
        public static string GenerateSalt()
        {
            //Random random = new Random();
            //string salt = "";

            //for (int i = 1; i <= 50; i++)
            //{
            //    int aleat = random.Next(1, 255);
            //    char letra = Convert.ToChar(aleat);
            //    salt += letra;
            //}
            //return salt;
            byte[] saltBytes = new byte[32]; // 32 bytes = 256 bits de seguridad
            using (var rng = new RNGCryptoServiceProvider())
            {
                rng.GetBytes(saltBytes);
            }
            return Convert.ToBase64String(saltBytes); // Devuelve un Salt en Base64
        }
        public static bool CompararArrays(byte[] a, byte[] b)
        {
            bool iguales = true;
            if (a.Length != b.Length)
            {
                iguales = false;
            }
            else
            {
                for (int i = 0; i < a.Length; i++)
                {
                    if (a[i].Equals(b[i]) == false)
                    {
                        iguales = false;
                        break;
                    }
                }
            }
            return iguales;
        }

        public static byte[] EncryptPassword(string password, string salt)
        {
            string contenido = password + salt;
            SHA512 managed = SHA512.Create();

            byte[] salida = Encoding.UTF8.GetBytes(contenido);

            for (int i = 1; i <= 15; i++)
            {
                salida = managed.ComputeHash(salida);
            }
            managed.Clear();
            return salida;
        }
    }

}
