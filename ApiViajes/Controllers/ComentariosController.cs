using ApiViajes.Repositories;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using NugetViajesSMG.Models;

namespace ApiViajes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ComentariosController : ControllerBase
    {
        private RepositoryComentarios repo;

        public ComentariosController(RepositoryComentarios repo)
        {
            this.repo = repo;
        }

        [HttpGet]
        public async Task<ActionResult<List<Comentario>>> GetComentarios()
        {
            return await this.repo.GetComentariosAsync();
        }

        [HttpGet("{idLugar}")]
        public async Task<ActionResult<List<Comentario>>> GetLugarComentarios(int idLugar)
        {
            return await this.repo.GetComentariosByLugarAsync(idLugar);
        }

        [HttpGet]
        [Route("[action]/{idComentario}")]
        public async Task<ActionResult<Comentario>> FindComentarios(int idComentario)
        {
            return await this.repo.FindComentariosAsync(idComentario);
        }


        [Authorize]
        [HttpPost]
        public async Task<ActionResult> InsertComentarios(Comentario coment)
        {
            await this.repo.InsertComentarioAsync(coment.IdComentario,
                coment.IdLugar,coment.IdUsuario,
                coment.Comentarios,coment.NombreUsuario
            );

            return Ok();
        }

        [Authorize]
        [HttpPut]
        [Route("[action]/{idComentario}")]
        public async Task<ActionResult> UpdateComentarios(int idComentario, Comentario coment)
        {
            await this.repo.UpdateComentarioAsync
                (coment.IdComentario, coment.IdLugar, coment.IdUsuario,
                coment.Comentarios, coment.NombreUsuario);
            return Ok();
        }

        [Authorize]
        [HttpDelete("{idComentario}")]
        public async Task<ActionResult> DeleteComentarios(int idComentario)
        {
            await this.repo.DeleteComentarioAsync(idComentario);
            return Ok();
        }
    }
}
