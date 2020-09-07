class Validacoes {
  String nomeValidacao(value) {
    if (value.isEmpty || value == null) return 'Informe o nome do filme';

    return null;
  }

  String autorValidacao(value) {
    if (value.isEmpty || value == null) return 'Informe o nome do autor';

    return null;
  }

  String anoValidacao(value) {
    if (value.isEmpty || value == null) return 'Informe o ano do filme';
    if (value.length != 4) return "Data inválida";

    return null;
  }
}
