using ApiViajes.Data;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using NugetViajesSMG.Models;

namespace ApiViajes.Repositories
{
    public class RepositoryComentarios
    {

        private ViajesContext context;

        public RepositoryComentarios(ViajesContext context)
        {
            this.context = context;
        }

        public async Task<List<Comentario>> GetComentariosAsync()
        {
            return await this.context.Comentarios.ToListAsync();
        }
        public async Task<List<Comentario>> GetComentariosByLugarAsync(int idLugar)
        {
            return await this.context.Comentarios
                .Where(x => x.IdLugar == idLugar)
                .ToListAsync();
        }

        public async Task<Comentario> FindComentariosAsync(int idComentario)
        {
            return await this.context.Comentarios.FirstOrDefaultAsync(x => x.IdComentario == idComentario);
        }

        public async Task InsertComentarioAsync(int idComentario, int idLugar, int idUsuario, string comentario, string nombreusuario)
        {
            Comentario coment = new Comentario();
            coment.IdComentario = idComentario;
            coment.IdLugar = idLugar;
            coment.IdUsuario = idUsuario;
            coment.Comentarios = comentario;
            coment.FechaComentario = DateTime.Now;
            coment.NombreUsuario = nombreusuario;

            await this.context.Comentarios.AddAsync(coment);
            await this.context.SaveChangesAsync();
        }


        public async Task UpdateComentarioAsync(int idComentario, int idLugar,
          int idUsuario, string comentario, string nombreusuario)
        {
            Comentario coment = await this.FindComentariosAsync(idComentario);
            coment.IdComentario = idComentario;
            coment.IdLugar = idLugar;
            coment.IdUsuario = idUsuario;
            coment.Comentarios = comentario;
            coment.FechaComentario = DateTime.Now;
            coment.NombreUsuario = nombreusuario;

            await this.context.SaveChangesAsync();
        }

        public async Task DeleteComentarioAsync(int idComentario)
        {
            Comentario coment = await this.FindComentariosAsync(idComentario);
            this.context.Comentarios.Remove(coment);
            await this.context.SaveChangesAsync();
        }
    }
}
