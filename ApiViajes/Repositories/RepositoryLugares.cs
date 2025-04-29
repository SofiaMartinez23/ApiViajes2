using ApiViajes.Data;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using NugetViajesSMG.Models;

namespace ApiViajes.Repositories
{
    public class RepositoryLugar
    {
        private readonly ViajesContext context;

        public RepositoryLugar(ViajesContext context)
        {
            this.context = context;
        }

        public async Task<List<Lugar>> GetLugaresAsync()
        {
            return await this.context.Lugares.ToListAsync();
        }
        public async Task<List<Lugar>> GetLugaresPorUsuarioAsync(int idUsuario)
        {
            return await this.context.Lugares
                .Where(l => l.IdUsuario == idUsuario)
                .ToListAsync();
        }


        public async Task<Lugar> FindLugarAsync(int idLugar)
        {
            return await this.context.Lugares.FirstOrDefaultAsync(l => l.IdLugar == idLugar);
        }

        public async Task<List<Lugar>> FindLugarByNameAsync(string searchTerm)
        {
            if (string.IsNullOrEmpty(searchTerm))
            {
                return new List<Lugar>();
            }

            string lowerSearchTerm = searchTerm.ToLower();

            return await this.context.Lugares
                .Where(l => l.Nombre.ToLower().Contains(lowerSearchTerm))
                .ToListAsync();
        }

        public async Task<List<Lugar>> GetLugaresPorTipoAsync(string tipo)
        {
            return await this.context.Lugares
                .Where(l => l.Tipo.ToLower() == tipo.ToLower())
                .ToListAsync();
        }

        public async Task InsertLugarAsync(int idlugar, string nombre, string descripcion,
            string ubicacion, string categoria, DateTime horario, string imagen, string tipo, int idusuario)
        {
            Lugar lugar = new Lugar();
            lugar.IdLugar = idlugar;
            lugar.Nombre = nombre;
            lugar.Descripcion = descripcion;
            lugar.Ubicacion = ubicacion;
            lugar.Categoria = categoria;
            lugar.Horario = horario;
            lugar.Imagen = imagen;
            lugar.Tipo = tipo;
            lugar.IdUsuario = idusuario;
            

            await this.context.Lugares.AddAsync(lugar);
            await this.context.SaveChangesAsync();
        }

        public async Task UpdateLugarAsync(int idlugar, string nombre, string descripcion,
             string ubicacion, string categoria, DateTime horario, string imagen, string tipo, int idusuario)
        {
            Lugar lugar = await this.FindLugarAsync(idlugar);
            lugar.IdLugar = idlugar;
            lugar.Nombre = nombre;
            lugar.Descripcion = descripcion;
            lugar.Ubicacion = ubicacion;
            lugar.Categoria = categoria;
            lugar.Horario = horario;
            lugar.Imagen = imagen;
            lugar.Tipo = tipo;
            lugar.IdUsuario = idusuario;

            await this.context.SaveChangesAsync();
        }

        public async Task DeleteLugarAsync(int idlugar)
        {

            var favoritos = await this.context.LugaresFavoritos
                .Where(f => f.IdLugar == idlugar)
                .ToListAsync();
                this.context.LugaresFavoritos.RemoveRange(favoritos);
            await this.context.SaveChangesAsync();


            var comentarios = await this.context.Comentarios
                .Where(c => c.IdLugar == idlugar)
                .ToListAsync();
           
                this.context.Comentarios.RemoveRange(comentarios);
            await this.context.SaveChangesAsync();


            Lugar lugar = await this.FindLugarAsync(idlugar);
            this.context.Lugares.Remove(lugar);
            await this.context.SaveChangesAsync();
        }

    }
}
