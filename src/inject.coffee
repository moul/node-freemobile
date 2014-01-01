class Inject

Inject::get_connected_url = ->
  return $('.acceuil_btn a:first').attr('href')

Inject::get_ident_div = ->
  return $('#ident_div_ident')

Inject::enter_credentials = (login, password) ->
  $('input[type="password"][name="pwd_abo"]').val(password)
  $('#ident_div_ident img[src^="chiffre.php"]').each ->
    console.log $(this).attr('src')
  return 42

module.exports = Inject