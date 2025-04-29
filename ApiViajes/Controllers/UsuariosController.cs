using ApiViajes.Helpers;
using ApiViajes.Repositories;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System.Security.Claims;
using NugetViajesSMG.Models;

namespace ApiViajes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UsuariosController : ControllerBase
    {
        private RepositoryUsuarios repo;
        private HelperUsuarioToken helper;

        public UsuariosController(RepositoryUsuarios repo, HelperUsuarioToken helper)
        {
            this.repo = repo;
            this.helper = helper;
        }

        [HttpGet]
        public async Task<ActionResult<List<UsuarioCompletoView>>> GetUsuarios()
        {
            return await this.repo.GetUsuariosAsync();
        }

        [Authorize]
        [HttpGet("{idUsuario}")]
        public async Task<ActionResult<UsuarioCompletoView>> FindUsuario(int idUsuario)
        {
            return await this.repo.FindUsuarioAsync(idUsuario);
        }

        [Authorize]
        [HttpGet("BuscarByNombre")]
        public async Task<ActionResult<List<UsuarioCompletoView>>> BuscarUsuario([FromQuery] string searchTerm)
        {
            return await this.repo.FindUsuariosByNameAsync(searchTerm);

        }

        [Authorize]
        [HttpGet]
        [Route("[action]")]
        public async Task<ActionResult<UsuarioModel>> Perfil()
        {
            UsuarioModel userModel = this.helper.GetUsuario();
            return userModel;
        }

        [HttpPost]
        [Route("[action]")]
        public async Task<ActionResult> InsertUsuario(UsuarioCompletoView user)
        {
            await this.repo.InsertUsuarioAsync
                (user.IdUsuario, user.Nombre, user.Email, user.Edad,
                user.Nacionalidad, user.PreferenciaViaje, user.Clave,
                user.ConfirmarClave, user.AvatarUrl);
            return Ok();
        }

        [Authorize]
        [HttpPut]
        [Route("[action]/{idUsuario}")]
        public async Task<ActionResult> UpdateUsuario(int idUsuario, UsuarioCompletoView user)
        {
            await this.repo.UpdateUsuarioAsync
                (user.IdUsuario,user.Nombre, user.Email, user.Edad,
                user.Nacionalidad, user.PreferenciaViaje, user.Clave,
                user.ConfirmarClave, user.AvatarUrl);
            return Ok();
        }

       
    }
}
