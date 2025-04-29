using ApiViajes.Helpers;
using NugetViajesSMG.Models;
using ApiViajes.Repositories;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using Newtonsoft.Json;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;

namespace ApiViajes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private RepositoryAuth repo;
        private HelperActionServicesOAuth helper;

        public AuthController(RepositoryAuth repo
            , HelperActionServicesOAuth helper)
        {
            this.repo = repo;
            this.helper = helper;
        }

        [HttpPost]
        [Route("[action]")]
        public async Task<ActionResult> Login(LoginModel model)
        {
            UsuarioCompletoView usuario = await this.repo.LogInUsuarioAsync(model.Email, model.Clave);

            if (usuario == null)
            {
                return Unauthorized();
            }

            SigningCredentials credentials = new SigningCredentials(
                this.helper.GetKeyToken(),
                SecurityAlgorithms.HmacSha256
            );

            UsuarioModel modelUser = new UsuarioModel
            {
                IdUsuario = usuario.IdUsuario,
                Nombre = usuario.Nombre,
                Email = usuario.Email,
                Edad = usuario.Edad,
                Nacionalidad = usuario.Nacionalidad,
                PreferenciaViaje = usuario.PreferenciaViaje,
                AvatarUrl = usuario.AvatarUrl,
                Clave = usuario.Clave,              
                ConfirmarClave = usuario.ConfirmarClave       
            };

            string jsonUsuario = JsonConvert.SerializeObject(modelUser);
            string jsonCifrado = HelperCryptography.EncryptString(jsonUsuario);

            Claim[] informacion = new[]
            {
                new Claim("UserData", jsonCifrado)
            };

            JwtSecurityToken token = new JwtSecurityToken(
                claims: informacion,
                issuer: this.helper.Issuer,
                audience: this.helper.Audience,
                signingCredentials: credentials,
                expires: DateTime.UtcNow.AddMinutes(20),
                notBefore: DateTime.UtcNow
            );

            return Ok(new
            {
                response = new JwtSecurityTokenHandler().WriteToken(token)
            });
        }

    }
}

