INCLUDE "game/src/common/constants.asm"

SECTION "Item Menu State Machine 1", ROMX[$4B3F], BANK[$06]
ItemMenuStateMachine::
  ld a, [W_CoreSubStateIndex]
  ld hl, .table
  rst $30
  jp hl

.table
  dw ItemMenuDrawingState
  dw ItemMenuMappingState
  dw ItemMenuPrepareFadeInState
  dw ItemMenuFadeInState
  dw ItemMenuItemSelectionInputHandlerState
  dw ItemMenuUseItemConfirmationState
  dw $4C34
  dw ItemMenuPrepareScriptEngineState
  dw $4C57
  dw $4C86
  dw ItemMenuPrepareScriptEngineState
  dw $4C6D
  dw $4C86
  dw $4C86
  dw $4C86
  dw $4C86
  dw $4C83
  dw $4C86
  
ItemMenuPrepareScriptEngineState::
  call WrapInitiateMainScript
  jp IncSubStateIndex

ItemMenuFadeInState::
  call $34E6
  ld a, [W_PaletteAnimRunning]
  or a
  ret nz
  jp IncSubStateIndex

ItemMenuDrawingState::
  call $3475
  ld bc, $11
  call WrapLoadMaliasGraphics
  ld bc, $13
  call WrapLoadMaliasGraphics
  ld bc, $18
  call WrapLoadMaliasGraphics
  ld bc, 5
  call $33C6
  call WrapInitiateMainScript
  jp IncSubStateIndex

ItemMenuMappingState::
  ld bc, 0
  ld e, $4F
  ld a, 0
  call WrapDecompressTilemap0
  ld bc, 0
  ld e, $4F
  ld a, 0
  call WrapDecompressAttribmap0
  call $4C87
  call $4CAE
  call $4CC4
  call $4D4E
  call $4D5F
  call $4D9A
  call $4DC1
  call $4DFA
  ld a, 1
  ld [W_OAM_SpritesReady], a
  jp IncSubStateIndex

ItemMenuPrepareFadeInState::
  ld hl, $2C
  ld bc, $16
  ld d, $FF
  ld e, $F0
  ld a, 8
  call WrapSetupPalswapAnimation
  jp IncSubStateIndex

ItemMenuItemSelectionInputHandlerState::
  call $5781
  ld de, $C0C0
  call $33B7
  call $4DAB
  call $4E07
  call $4EF2
  call $4E31
  call $4F96
  call $4FDA
  call $5055
  ld a, [$C4EE]
  or a
  jp nz, IncSubStateIndex
  call $5031
  ld a, [$C4EE]
  cp 1
  ret nz

.doExit
  ld a, $A
  ld [W_CoreStateIndex], a
  ld a, 7
  ld [W_CoreSubStateIndex], a
  ret

ItemMenuUseItemConfirmationState::
  call $5781
  ld a, 2
  call $35DA
  ld a, [$C771]
  or a
  ret z
  cp 1
  jp z, IncSubStateIndex
  ld a, 4
  ld [W_CoreSubStateIndex], a
  ret