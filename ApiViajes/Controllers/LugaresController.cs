
using ApiViajes.Repositories;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using NugetViajesSMG.Models;
using static System.Net.Mime.MediaTypeNames;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace ApiViajes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class LugaresController : ControllerBase
    {
        private RepositoryLugar repo;

        public LugaresController(RepositoryLugar repo)
        {
            this.repo = repo;
        }

        [HttpGet]
        public async Task<ActionResult<List<Lugar>>> GetLugares()
        {
            return await this.repo.GetLugaresAsync();
        }

        [HttpGet("{idLugar}")]
        public async Task<ActionResult<Lugar>> GetLugar(int idLugar)
        {
            return await this.repo.FindLugarAsync(idLugar);
        }

        [HttpGet("BuscarByNombre")]
        public async Task<ActionResult<List<Lugar>>> BuscarLugares([FromQuery] string searchTerm)
        {
            return await this.repo.FindLugarByNameAsync(searchTerm);

        }

        [HttpGet("Tipo/{tipo}")]
        public async Task<ActionResult<List<Lugar>>> GetLugaresPorTipo(string tipo)
        {
            return await this.repo.GetLugaresPorTipoAsync(tipo);
           
        }

        [HttpGet("LugaresUsuario/{idUsuario}")]
        public async Task<IActionResult> GetLugaresPorUsuario(int idUsuario)
        {
            try
            {
                var lugares = await this.repo.GetLugaresPorUsuarioAsync(idUsuario);

                if (lugares == null || lugares.Count == 0)
                {
                    return NotFound("No se encontraron lugares para este usuario.");
                }

                return Ok(lugares);
            }
            catch (Exception ex)
            {
                // Aquí se captura cualquier excepción inesperada y se devuelve un error 500
                return StatusCode(500, $"Error interno del servidor: {ex.Message}");
            }
        }



        [Authorize]
        [HttpPost]
        public async Task<ActionResult> InsertLugar(Lugar lugar)
        {
            await this.repo.InsertLugarAsync
                (lugar.IdLugar, lugar.Nombre,
                lugar.Descripcion, lugar.Ubicacion,lugar.Categoria, 
                lugar.Horario,lugar.Imagen, lugar.Tipo, lugar.IdUsuario);
            return Ok();
        }

        [Authorize]
        [HttpPut]
        [Route("[action]/{idLugar}")]
        public async Task<ActionResult> UpdateLugar(int idLugar, Lugar lugar)
        {
            await this.repo.UpdateLugarAsync
                (lugar.IdLugar, lugar.Nombre,
                lugar.Descripcion, lugar.Ubicacion, lugar.Categoria,
                lugar.Horario, lugar.Imagen, lugar.Tipo, lugar.IdUsuario);
            return Ok();
        }

        [Authorize]
        [HttpDelete("{idLugar}")]
        public async Task<ActionResult> DeleteLugar(int idLugar)
        {
            await this.repo.DeleteLugarAsync(idLugar);
            return Ok();
        }
    }
}
