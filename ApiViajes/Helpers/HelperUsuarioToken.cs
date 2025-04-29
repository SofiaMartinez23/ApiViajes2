using NugetViajesSMG.Models;
using Newtonsoft.Json;
using System.Security.Claims;

namespace ApiViajes.Helpers
{
    public class HelperUsuarioToken
    {
        private IHttpContextAccessor contextAccessor;

        public HelperUsuarioToken(IHttpContextAccessor contextAccessor)
        {
            this.contextAccessor = contextAccessor;
        }

        public UsuarioModel GetUsuario()
        {
            Claim claim = contextAccessor.HttpContext
                .User.FindFirst(x => x.Type == "UserData");

            if (claim == null)
            {
                throw new UnauthorizedAccessException("No se encontró el claim 'UserData'.");
            }

            string json = claim.Value;
            string jsonUsuario = HelperCryptography.DecryptString(json);
            UsuarioModel model = JsonConvert.DeserializeObject<UsuarioModel>(jsonUsuario);
            return model;
        }
    }
}
