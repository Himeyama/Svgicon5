!define MUI_ICON "SVG2ICO.ico"
!define PRODUCT_NAME "SVG2ICO"
!define INSTALL_DIR "$LOCALAPPDATA\SVG2ICO" # �C���X�g�[����
!define PUBLISH_DIR "Svgicon5\bin\x64\Release\net7.0-windows10.0.19041.0\win-x64"
!define EXEC_FILE "SVG2ICO.exe"
!define PRODUCT_PUBLISHER "�Ђ���"

# Modern UI
!include MUI2.nsh
# nsDialogs
!include nsDialogs.nsh
# LogicLib
!include LogicLib.nsh

# �A�v���P�[�V������
Name "${PRODUCT_NAME}"

BrandingText "${PRODUCT_NAME} v${VERSION}"

# �쐬�����C���X�g�[��
OutFile "Install.exe"

# �C���X�g�[�������f�B���N�g��
InstallDir "${INSTALL_DIR}"

# �A�C�R��
Icon "${MUI_ICON}"
UninstallIcon "${MUI_ICON}"

# �y�[�W
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE LICENSE.txt
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

!insertmacro MUI_LANGUAGE "Japanese"

# �f�t�H���g �Z�N�V����
Section
    # �o�͐���w�肵�܂��B
    SetOutPath "$INSTDIR"

    # �C���X�g�[�������t�@�C��
    File /r "${PUBLISH_DIR}\\*.*"
    File "${MUI_ICON}"

    # �A���C���X�g�[�����o��
    WriteUninstaller "$INSTDIR\\Uninstall.exe"

    # �X�^�[�g ���j���[�ɃV���[�g�J�b�g��o�^
    CreateDirectory "$SMPROGRAMS\\${PRODUCT_NAME}"
    SetOutPath "$INSTDIR"
    CreateShortcut "$SMPROGRAMS\\${PRODUCT_NAME}\\${PRODUCT_NAME}.lnk" "$INSTDIR\\${EXEC_FILE}" "" "$INSTDIR\\${MUI_ICON}"

    # ���W�X�g���ɓo�^
    WriteRegStr HKLM "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\${PRODUCT_NAME}" "DisplayName" "${PRODUCT_NAME}"
    WriteRegStr HKLM "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\${PRODUCT_NAME}" "UninstallString" '"$INSTDIR\Uninstall.exe"'
    WriteRegStr HKLM "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\${PRODUCT_NAME}" "Publisher" "${PRODUCT_PUBLISHER}"
    WriteRegStr HKLM "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\${PRODUCT_NAME}" "DisplayIcon" "$INSTDIR\${MUI_ICON}"
    WriteRegStr HKLM "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\${PRODUCT_NAME}" "DisplayVersion" "${VERSION}"
    WriteRegStr HKLM "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\${PRODUCT_NAME}" "InstallDate" "${DATE}"
    WriteRegDWORD HKLM "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\${PRODUCT_NAME}" "EstimatedSize" "${SIZE}"
SectionEnd

# �A���C���X�g�[��
Section "Uninstall"
    # �A���C���X�g�[�����폜
    Delete "$INSTDIR\\Uninstall.exe"

    # �t�@�C�����폜
    Delete "$INSTDIR\\${EXEC_FILE}"

    # �f�B���N�g�����폜
    RMDir /r "$INSTDIR"

    # �X�^�[�g ���j���[����폜
    Delete "$SMPROGRAMS\\${PRODUCT_NAME}\\${PRODUCT_NAME}.lnk"
    RMDir "$SMPROGRAMS\\${PRODUCT_NAME}"

    # ���W�X�g�� �L�[���폜
    DeleteRegKey HKLM "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\${PRODUCT_NAME}"
SectionEnd