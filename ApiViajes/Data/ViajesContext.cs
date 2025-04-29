using Microsoft.EntityFrameworkCore;
using NugetViajesSMG.Models;

namespace ApiViajes.Data
{
    public class ViajesContext: DbContext
    {
        public ViajesContext(DbContextOptions<ViajesContext>
            options) : base(options) { }

        public DbSet<Lugar> Lugares { get; set; }
        public DbSet<LugarFavorito> LugaresFavoritos { get; set; }
        public DbSet<Comentario> Comentarios { get; set; }
        public DbSet<Chat> Chats { get; set; }
        public DbSet<UsuarioSeguidoPerfil> UsuarioSeguidoPerfiles { get; set; }
        public DbSet<Seguidor> Seguidores { get; set; }

        public DbSet<UsuarioCompletoView> UsuarioCompletoViews { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<Chat>()
                .HasOne(c => c.UsuarioRemitente)
                .WithMany()
                .HasForeignKey(c => c.IdUsuarioRemitente)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Chat>()
                .HasOne(c => c.UsuarioDestinatario)
                .WithMany()
                .HasForeignKey(c => c.IdUsuarioDestinatario)
                .OnDelete(DeleteBehavior.Restrict);
        }


    }
}
