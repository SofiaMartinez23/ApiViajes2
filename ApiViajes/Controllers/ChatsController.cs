using ApiViajes.Repositories;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;
using NugetViajesSMG.Models;

namespace ApiViajes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ChatsController : ControllerBase
    {
        private RepositoryChats repo;

        public ChatsController(RepositoryChats repo)
        {
            this.repo = repo;
        }

        [Authorize]
        [HttpGet("Conversacion")]
        public async Task<ActionResult<List<Chat>>> GetChat([FromQuery] int userRemitente, [FromQuery] int userDestinatario)
        {
            var chat = await this.repo.GetChatAsync(userRemitente, userDestinatario);
            return Ok(chat);
        }

        [Authorize]
        [HttpGet("Mensaje/{idRemitente}")]
        public async Task<ActionResult<Chat>> GetPrimerMensaje(int idRemitente)
        {
            var chat = await this.repo.FindChatAsync(idRemitente);
            if (chat == null)
                return NotFound();
            return Ok(chat);
        }

        [Authorize]
        [HttpPost("Enviar")]
        public async Task<ActionResult> InsertarMensaje([FromBody] Chat mensaje)
        {
            await this.repo.InsertMessageAsync(mensaje.IdMensaje, mensaje.IdUsuarioRemitente, mensaje.IdUsuarioDestinatario, mensaje.Mensaje);
            return Ok(new { mensaje = "Mensaje enviado correctamente." });
        }

        [Authorize]
        [HttpPut("Actualizar/{idMensaje}")]
        public async Task<ActionResult> ActualizarMensaje(int idMensaje, [FromBody] Chat mensaje)
        {
            await this.repo.UpdateMessageAsync(mensaje.IdMensaje, mensaje.IdUsuarioRemitente, mensaje.IdUsuarioDestinatario, mensaje.Mensaje);
            return Ok(new { mensaje = "Mensaje actualizado correctamente." });
        }


        [Authorize]
        [HttpDelete("Eliminar/{idRemitente}")]
        public async Task<ActionResult> EliminarMensaje(int idRemitente)
        {
            await this.repo.DeleteMessageAsync(idRemitente);
            return Ok(new { mensaje = "Mensaje eliminado correctamente." });
        }
    }
}
