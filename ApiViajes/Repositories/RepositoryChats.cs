using ApiViajes.Data;
using Microsoft.EntityFrameworkCore;
using NugetViajesSMG.Models;

namespace ApiViajes.Repositories
{
    public class RepositoryChats
    {

        private ViajesContext context;

        public RepositoryChats(ViajesContext context)
        {
            this.context = context;
        }

        public async Task<List<Chat>> GetChatAsync(int usuarioId1, int usuarioId2)
        {
            return await this.context.Chats
                .Where(c => (c.IdUsuarioRemitente == usuarioId1 && c.IdUsuarioDestinatario == usuarioId2) ||
                           (c.IdUsuarioRemitente == usuarioId2 && c.IdUsuarioDestinatario == usuarioId1))
                .OrderBy(c => c.FechaEnvio)
                .ToListAsync();
        }

        public async Task<Chat> FindChatAsync(int idremitente)
        {
            return await this.context.Chats.FirstOrDefaultAsync(x => x.IdUsuarioRemitente == idremitente);

        }

        public async Task InsertMessageAsync(int idmensaje, int idremitente, int iddestinatario, string mensaje)
        {
            Chat chat = new Chat();
            chat.IdMensaje = idmensaje;
            chat.IdUsuarioRemitente = idremitente;
            chat.IdUsuarioDestinatario = iddestinatario;
            chat.Mensaje = mensaje;
            chat.FechaEnvio = DateTime.UtcNow;

            await this.context.Chats.AddAsync(chat);
            await this.context.SaveChangesAsync();
        }

        public async Task UpdateMessageAsync(int idmensaje, int idremitente, int iddestinatario, string mensaje)
        {
            Chat chat = await this.FindChatAsync(idremitente);
            chat.IdMensaje = idmensaje;
            chat.IdUsuarioRemitente = idremitente;
            chat.IdUsuarioDestinatario = iddestinatario;
            chat.Mensaje = mensaje;
            chat.FechaEnvio = DateTime.UtcNow;

            await this.context.SaveChangesAsync();
        }

        public async Task DeleteMessageAsync(int idremitente)
        {
            Chat chat = await this.FindChatAsync(idremitente);
            this.context.Chats.Remove(chat);
            await this.context.SaveChangesAsync();
        }
    }
}
