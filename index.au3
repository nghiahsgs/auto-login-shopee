#include <_HttpRequest.au3>
#include <File.au3>
#include <Crypt.au3>



$CALG_SHA256 = 0x0000800c

Func maHoaPassShopee($passwordOri)

	;ma hoa password md5
	;$passwordOri = 'mk321123@A'
	$passwordMD5 = md5String($passwordOri)
	;;;MsgBox(0,0,$passwordMD5)

	;ma hoa password 256
	$passwordSHA256 = SHA256String($passwordMD5)
	;;;MsgBox(0,0,$passwordSHA256)
	Return $passwordSHA256

EndFunc   ;==>maHoaPassShopee



;$typeLogin =1 // phone
;			2	//username
$typeLogin =2
$usernameLogin='congdongnghichmaytinh'
$passwordOri='Congdong97@'

$passmaHoaPassShopee = maHoaPassShopee($passwordOri)
$kq = loginShopee($usernameLogin, $passmaHoaPassShopee, $typeLogin)


Func loginShopee($usernameLogin, $passLogin, $typeLogin)
	_HttpRequest_NewSession()
	;#cs
	$cookie='_gcl_au=1.1.964495125.1569103720; csrftoken=iC7RyzO3IwwvUSEJ9zVSlU0NOL4LYiv4; SPC_IA=-1; SPC_EC=-; REC_MD_20=1569128942; SPC_U=-; REC_MD_14=1569129018; SPC_F=GAkl7s4eiQUkKp4DQ9ermsP48VzVS0aR; REC_T_ID=0ff513dc-dcf7-11e9-910e-3c15fb3af133; REC_MD_25=1569129107; SPC_SI=1ujrtycdekn6mtiqezvxazyjen1kmirl; welcomePkgShown=true; _fbp=fb.1.1569103721629.163192668; SPC_T_IV="uWlYH0JBUZofQrrQ95j69A=="; SPC_T_ID="7WCqb56yGv58rHka7YZBPiN7B2j6shwO+7o772yA5B2VT/cMdoEp3IDM1CzNzgJHgzGoCVzPFYHfUm5wDqlG9Zt96moUh7Zb5/1CStY/OoI="; REC_MD_30_2000109347=1569129218; _hjid=a0407487-f836-4e25-a7bd-90a63ca9dcc0; AMP_TOKEN=%24NOT_FOUND; _ga=GA1.2.686484597.1569103724; _gid=GA1.2.1257150950.1569103724; _dc_gtm_UA-61914164-6=1'
	$csrftoken = StringRegExp($cookie, 'csrftoken=(.*?);', 1)

	If IsArray($csrftoken) Then
		$csrftoken = $csrftoken[0]
	Else
		Return "error_csrftoken"
	EndIf


	;Get Cookie after login
	$boundaryIndex = randomString(16)

	$dataPost = FileRead('dataPost.txt')
	$dataPost = StringReplace($dataPost, '_nghiahsgs', $boundaryIndex)
	$dataPost = StringReplace($dataPost, 'usernameLogin', $usernameLogin)
	$dataPost = StringReplace($dataPost, 'passLogin', $passLogin)

	If $typeLogin = 2 Then ;//username
		$dataPost = StringReplace($dataPost, 'phone', 'username')
	EndIf

	;;MsgBox(0, 0, $dataPost)



	$add = 'referer: https://shopee.vn/'
	$add &= '|content-type: multipart/form-data; boundary=----WebKitFormBoundary' & $boundaryIndex
	$add &= '|user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36'
	$add &= '|x-api-source: pc'
	$add &= '|x-csrftoken: ' & $csrftoken
	$add &= '|x-requested-with: XMLHttpRequest'


	$request = _HttpRequest(2, 'https://shopee.vn/api/v0/buyer/login/login_post/', $dataPost, $cookie, '', $add)

	MsgBox(0, 0, $request)
	If StringReplace($request, 'buyer', '') = $request Then
		Return 'error_login_finish'
	EndIf

	$request = _HttpRequest(2, 'https://banhang.shopee.vn/api/v2/login/', $dataPost, $cookie)
	MsgBox(0, 0, $request)


;	$kq = followUserByCookie($cookie, $usernamesShop)
;	Return $kq
EndFunc   ;==>loginAndFollowShopee



Func randomString($digits)
	$pwd = ""
	Dim $aSpace[3]
	For $i = 1 To $digits
		$aSpace[0] = Chr(Random(65, 90, 1)) ;A-Z
		$aSpace[1] = Chr(Random(97, 122, 1)) ;a-z
		$aSpace[2] = Chr(Random(48, 57, 1)) ;0-9
		$pwd &= $aSpace[Random(0, 2, 1)]
	Next
	Return $pwd
EndFunc   ;==>randomString

Func md5String($passwordOri)
	$passwordMD5 = StringLower(_Crypt_HashData($passwordOri, $CALG_MD5))
	;;;MsgBox(0,0,$passwordMD5)
	$passwordMD5 = StringRight($passwordMD5, StringLen($passwordMD5) - 2)
	;;;MsgBox(0,0,$passwordMD5)
	Return $passwordMD5
EndFunc   ;==>md5String

Func SHA256String($passwordOri)

	$passwordSHA256 = StringLower(_Crypt_HashData($passwordOri, $CALG_SHA256))
	$passwordSHA256 = StringRight($passwordSHA256, StringLen($passwordSHA256) - 2)
	;;;MsgBox(0,0,$passwordSHA256)
	Return $passwordSHA256
EndFunc   ;==>SHA256String

