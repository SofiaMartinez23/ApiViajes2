
using ApiViajes.Repositories;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using NugetViajesSMG.Models;
using static System.Net.Mime.MediaTypeNames;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace ApiViajes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class FavoritosController : ControllerBase
    {
        private RepositoryFavoritos repo;

        public FavoritosController(RepositoryFavoritos repo)
        {
            this.repo = repo;
        }

        [HttpGet]
        [Authorize]
        public async Task<ActionResult<List<LugarFavorito>>> GetLugarFavorito()
        {
            return await this.repo.GetFavoritosAsync();
        }

        [HttpGet("{idUsuario}")]
        [Authorize]
        public async Task<ActionResult<List<LugarFavorito>>> FindLugarFavorito(int idUsuario)
        {
            return await this.repo.FindFavoritosLugarAsync(idUsuario);
        }

        [HttpPost]
        [Authorize]
        public async Task<ActionResult> InsertLugarFavorito(LugarFavorito favorito)
        {
            await this.repo.InsertFavoritoAsync
                (favorito.IdFavorito ,favorito.IdUsuario,favorito.IdLugar,favorito.FechaDeVisitaLugar, 
                favorito.ImagenLugar,favorito.NombreLugar,favorito.DescripcionLugar, 
                favorito.UbicacionLugar, favorito.TipoLugar); 
            return Ok();
        }

        [Authorize]
        [HttpDelete("{idLugar}")]
        public async Task<ActionResult> DeleteSeguidor(int idLugar)
        {
            await this.repo.DeleteFavoritoAsync(idLugar);
            return Ok();
        }


        [Authorize]
        [HttpGet("IdsFavoritos/{idUsuario}")]
        public async Task<ActionResult<List<int>>> GetIdsFavoritos(int idUsuario)
        {
            var ids = await this.repo.GetIdsLugaresFavoritosPorUsuarioAsync(idUsuario);
            return Ok(ids);
        }

    }
}
