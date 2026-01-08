using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace PSYCare.Migrations
{
    /// <inheritdoc />
    public partial class UpdateEntitiesFields : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Patients_Psychologists_PsychologistId",
                table: "Patients");

            migrationBuilder.DropIndex(
                name: "IX_Patients_Email",
                table: "Patients");

            migrationBuilder.DropColumn(
                name: "Faculty",
                table: "Patients");

            migrationBuilder.RenameColumn(
                name: "Problem",
                table: "Patients",
                newName: "IssueDescription");

            migrationBuilder.AlterColumn<int>(
                name: "PsychologistId",
                table: "Patients",
                type: "integer",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "integer");

            migrationBuilder.AlterColumn<string>(
                name: "Name",
                table: "Patients",
                type: "text",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100);

            migrationBuilder.AlterColumn<string>(
                name: "Email",
                table: "Patients",
                type: "text",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(256)",
                oldMaxLength: 256);

            migrationBuilder.AddForeignKey(
                name: "FK_Patients_Psychologists_PsychologistId",
                table: "Patients",
                column: "PsychologistId",
                principalTable: "Psychologists",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Patients_Psychologists_PsychologistId",
                table: "Patients");

            migrationBuilder.RenameColumn(
                name: "IssueDescription",
                table: "Patients",
                newName: "Problem");

            migrationBuilder.AlterColumn<int>(
                name: "PsychologistId",
                table: "Patients",
                type: "integer",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "integer",
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "Name",
                table: "Patients",
                type: "character varying(100)",
                maxLength: 100,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "text");

            migrationBuilder.AlterColumn<string>(
                name: "Email",
                table: "Patients",
                type: "character varying(256)",
                maxLength: 256,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "text");

            migrationBuilder.AddColumn<string>(
                name: "Faculty",
                table: "Patients",
                type: "text",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Patients_Email",
                table: "Patients",
                column: "Email",
                unique: true);

            migrationBuilder.AddForeignKey(
                name: "FK_Patients_Psychologists_PsychologistId",
                table: "Patients",
                column: "PsychologistId",
                principalTable: "Psychologists",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
