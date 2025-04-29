using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;
using System.Collections.Generic;
using NugetViajesSMG.Models;
using Microsoft.AspNetCore.Authorization;
using ApiViajes.Repositories;
using System.Security.Claims;

namespace ApiViajes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SeguidoresController : ControllerBase
    {
        private RepositorySeguidos repo;

        public SeguidoresController(RepositorySeguidos repo)
        {
            this.repo = repo;
        }

        [Authorize]
        [HttpGet("Seguidores/{idUsuario}")]
        public async Task<ActionResult<List<UsuarioSeguidoPerfil>>> GetSeguidores(int idUsuario)
        {
            var seguidores = await this.repo.GetSeguidoresAsync(idUsuario);
            return Ok(seguidores);
        }

        [Authorize]
        [HttpGet("Seguidos/{idUsuario}")]
        public async Task<ActionResult<List<UsuarioSeguidoPerfil>>> GetSeguidos(int idUsuario)
        {
            var seguidos = await this.repo.GetSeguidosAsync(idUsuario);
            return Ok(seguidos);
        }

        [Authorize]
        [HttpGet("IdsSeguidos/{idUsuario}")]
        public async Task<ActionResult<List<int>>> GetIdsSeguidos(int idUsuario)
        {
            var ids = await this.repo.GetIdsSeguidosPorUsuarioAsync(idUsuario);
            return Ok(ids);
        }

        [Authorize]
        [HttpPost]
        [Route("[action]")]
        public async Task<ActionResult> InsertSeguidor(Seguidor seguir)
        {
            await this.repo.InsertSeguidorAsync
                (seguir.IdUsuarioSeguidor, seguir.IdUsuarioSeguido);
            return Ok();
        }

        [Authorize]
        [HttpDelete("{seguidoId}")]
        public async Task<ActionResult> DeleteSeguidor(int seguidoId)
        {
            await this.repo.DeleteSeguidorAsync(seguidoId);
            return Ok();
        }

    }
}
