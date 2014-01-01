class Inject
module.exports = Inject


Inject::utils = ->


  window.getImageBase64 = (img, format='image/png') ->
    canvas = document.createElement 'canvas'
    ctx = canvas.getContext '2d'
    canvas.width = img.width
    canvas.height = img.height
    ctx.drawImage img, 0, 0
    return canvas.toDataURL format


  window.getImageObjs = ->
    objs = []
    for pos in [0...10]
      objs[pos] = $("#ident_div_ident img[src^='chiffre.php?']:nth(#{pos})")
    if objs.length != 10
      throw "Bad image count"
    return objs


  window.getPixelCoord = (x, y, width) ->
    return (y * width * 4) + x * 4


  window.getPixel = (data, x, y, width) ->
    pixelCoord = getPixelCoord x, y , width
    r = data.data[pixelCoord + 0] / 32
    g = data.data[pixelCoord + 1] / 32
    b = data.data[pixelCoord + 2] / 32
    a = data.data[pixelCoord + 3] != 0
    return a and r != g and r != b


  window.setPixel = (data, x, y, width, value) ->
    pixelCoord = getPixelCoord x, y , width
    setValue = if value then 0 else 255
    data.data[pixelCoord + 0] = setValue
    data.data[pixelCoord + 1] = setValue
    data.data[pixelCoord + 2] = setValue
    data.data[pixelCoord + 3] = 255


  window.getSibblings = (imageData, x, y, width, height) ->
    sibblings = 0
    for dx in [-1..1]
      for dy in [-1..1]
        if dx is 0 and dy is 0
          continue
        if x + dx >= width or x + dx < 0 or y + dy >= height or y + dy < 0
          continue
        if getPixel imageData, x + dx, y + dx, width
          sibblings++
    return sibblings


  window.getOptimizedImage = (img) ->
    canvas = document.createElement 'canvas'
    if img.width != img.height
      throw "Bad image size"
    halfSize = img.width / 2
    canvas.width = canvas.height = halfSize
    ctx = canvas.getContext '2d'
    ctx.drawImage(
      img
      img.width / 2 - halfSize / 2
      img.height / 2 - halfSize / 2
      halfSize
      halfSize
      0
      0
      halfSize
      halfSize
      )
    imageData = ctx.getImageData 0, 0, halfSize, halfSize
    minX = halfSize
    minY = halfSize
    maxX = 0
    maxY = 0
    for x in [0...halfSize]
      for y in [0...halfSize]
        mainPixel = getPixel imageData, x, y, halfSize
        sibblingPixels = getSibblings imageData, x, y, halfSize, halfSize
        pixelValue = mainPixel and sibblingPixels >= 2
        if pixelValue
          maxX = Math.max maxX, x
          maxY = Math.max maxY, y
          minX = Math.min minX, x
          minY = Math.min minY, y
        setPixel imageData, x, y, halfSize, pixelValue
    ctx.putImageData imageData, 0, 0
    ret =
      min:
        x: minX
        y: minY
      max:
        x: maxX
        y: maxY
      canvas: canvas
    return ret

  window.crc32 = (str) ->
    table = "00000000 77073096 EE0E612C 990951BA 076DC419 706AF48F E963A535 " +
      "9E6495A3 0EDB8832 79DCB8A4 E0D5E91E 97D2D988 09B64C2B 7EB17CBD E7B82D07 " +
      "90BF1D91 1DB71064 6AB020F2 F3B97148 84BE41DE 1ADAD47D 6DDDE4EB F4D4B551 " +
      "83D385C7 136C9856 646BA8C0 FD62F97A 8A65C9EC 14015C4F 63066CD9 FA0F3D63 " +
      "8D080DF5 3B6E20C8 4C69105E D56041E4 A2677172 3C03E4D1 4B04D447 D20D85FD " +
      "A50AB56B 35B5A8FA 42B2986C DBBBC9D6 ACBCF940 32D86CE3 45DF5C75 DCD60DCF " +
      "ABD13D59 26D930AC 51DE003A C8D75180 BFD06116 21B4F4B5 56B3C423 CFBA9599 " +
      "B8BDA50F 2802B89E 5F058808 C60CD9B2 B10BE924 2F6F7C87 58684C11 C1611DAB " +
      "B6662D3D 76DC4190 01DB7106 98D220BC EFD5102A 71B18589 06B6B51F 9FBFE4A5 " +
      "E8B8D433 7807C9A2 0F00F934 9609A88E E10E9818 7F6A0DBB 086D3D2D 91646C97 " +
      "E6635C01 6B6B51F4 1C6C6162 856530D8 F262004E 6C0695ED 1B01A57B 8208F4C1 " +
      "F50FC457 65B0D9C6 12B7E950 8BBEB8EA FCB9887C 62DD1DDF 15DA2D49 8CD37CF3 " +
      "FBD44C65 4DB26158 3AB551CE A3BC0074 D4BB30E2 4ADFA541 3DD895D7 A4D1C46D " +
      "D3D6F4FB 4369E96A 346ED9FC AD678846 DA60B8D0 44042D73 33031DE5 AA0A4C5F " +
      "DD0D7CC9 5005713C 270241AA BE0B1010 C90C2086 5768B525 206F85B3 B966D409 " +
      "CE61E49F 5EDEF90E 29D9C998 B0D09822 C7D7A8B4 59B33D17 2EB40D81 B7BD5C3B " +
      "C0BA6CAD EDB88320 9ABFB3B6 03B6E20C 74B1D29A EAD54739 9DD277AF 04DB2615 " +
      "73DC1683 E3630B12 94643B84 0D6D6A3E 7A6A5AA8 E40ECF0B 9309FF9D 0A00AE27 " +
      "7D079EB1 F00F9344 8708A3D2 1E01F268 6906C2FE F762575D 806567CB 196C3671 " +
      "6E6B06E7 FED41B76 89D32BE0 10DA7A5A 67DD4ACC F9B9DF6F 8EBEEFF9 17B7BE43 " +
      "60B08ED5 D6D6A3E8 A1D1937E 38D8C2C4 4FDFF252 D1BB67F1 A6BC5767 3FB506DD " +
      "48B2364B D80D2BDA AF0A1B4C 36034AF6 41047A60 DF60EFC3 A867DF55 316E8EEF " +
      "4669BE79 CB61B38C BC66831A 256FD2A0 5268E236 CC0C7795 BB0B4703 220216B9 " +
      "5505262F C5BA3BBE B2BD0B28 2BB45A92 5CB36A04 C2D7FFA7 B5D0CF31 2CD99E8B " +
      "5BDEAE1D 9B64C2B0 EC63F226 756AA39C 026D930A 9C0906A9 EB0E363F 72076785 " +
      "05005713 95BF4A82 E2B87A14 7BB12BAE 0CB61B38 92D28E9B E5D5BE0D 7CDCEFB7 " +
      "0BDBDF21 86D3D2D4 F1D4E242 68DDB3F8 1FDA836E 81BE16CD F6B9265B 6FB077E1 " +
      "18B74777 88085AE6 FF0F6A70 66063BCA 11010B5C 8F659EFF F862AE69 616BFFD3 " +
      "166CCF45 A00AE278 D70DD2EE 4E048354 3903B3C2 A7672661 D06016F7 4969474D " +
      "3E6E77DB AED16A4A D9D65ADC 40DF0B66 37D83BF0 A9BCAE53 DEBB9EC5 47B2CF7F " +
      "30B5FFE9 BDBDF21C CABAC28A 53B39330 24B4A3A6 BAD03605 CDD70693 54DE5729 " +
      "23D967BF B3667A2E C4614AB8 5D681B02 2A6F2B94 B40BBE37 C30C8EA1 5A05DF1B " +
      "2D02EF8D"
    crc = 0
    x = 0
    y = 0
    crc = crc ^ (-1)
    for i in [0...str.length]
      y = (crc ^ str.charCodeAt(i)) & 0xFF
      x = "0x" + table.substr(y * 9, 8)
      crc = (crc >>> 8) ^ x
    return crc ^ (-1)


  window.getImageHash = (img) ->
    optimized = getOptimizedImage img
    canvas = document.createElement 'canvas'
    ctx = canvas.getContext '2d'
    canvas.width = optimized.max.x - optimized.min.x + 1
    canvas.height = optimized.max.y - optimized.min.y + 1
    ctx.drawImage(
      optimized.canvas
      optimized.min.x
      optimized.min.y
      canvas.width
      canvas.height
      0
      0
      canvas.width
      canvas.height
      )
    dataUrl = canvas.toDataURL()
    return crc32 dataUrl


Inject::getConnectedUrl = ->
  return $('.acceuil_btn a:first').attr('href')


Inject::getIdentDiv = ->
  return $('#ident_div_ident')


Inject::getSmallImages = ->
  data = []
  smallImages = []
  for _imageId in [0...10]
    do ->
      imageId = _imageId
      smallImages[imageId] = new Image()
      smallImages.onload = ->
        data[imageId] = getImageBase64 this
      smallImages[imageId].src = "chiffre.php?pos=#{imageId}&small=1"
      $('body').append smallImages[imageId]
  return data


Inject::getImagesData = ->
  data = []
  for img in getImageObjs()
    data.push getImageBase64(img[0])
  return data


Inject::getImagesHash = ->
  hashes = []
  for img in getImageObjs()
    hashes.push getImageHash(img[0])
  return hashes


Inject::enterCredentials = (login, password) ->
  $('input[type="password"][name="pwd_abo"]').val(password)
  #$('#ident_div_ident img[src^="chiffre.php"]').each ->
  #  console.log $(this).attr('src')
