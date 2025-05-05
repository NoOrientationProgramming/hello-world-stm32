/*
  This file is part of the DSP-Crowd project
  https://www.dsp-crowd.com

  Author(s):
      - Johannes Natter, office@dsp-crowd.com

  File created on 24.03.2025

  Copyright (C) 2025, Johannes Natter

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
*/

#include "main.h"

#include "StmSupervising.h"
#include "SystemDebugging.h"
#include "InfoTesting.h"

#define dForEach_ProcState(gen) \
		gen(StStart) \
		gen(StDbgReadyWait) \
		gen(StMain) \

#define dGenProcStateEnum(s) s,
dProcessStateEnum(ProcState);

#if 1
#define dGenProcStateString(s) #s,
dProcessStateStr(ProcState);
#endif

using namespace std;

extern UART_HandleTypeDef huart2;
UART_HandleTypeDef *pUartSwt = &huart2;
static char bufSwtRx;

SystemDebugging *pDbg = NULL;

StmSupervising::StmSupervising()
	: Processing("StmSupervising")
	//, mStartMs(0)
	, mCntCycles(0)
{
	mState = StStart;
}

/* member functions */

Success StmSupervising::process()
{
	//uint32_t curTimeMs = millis();
	//uint32_t diffMs = curTimeMs - mStartMs;
	//Success success;
	Processing *pProc;
#if 0
	dStateTrace;
#endif
	switch (mState)
	{
	case StStart:

		cntTimeCreateSet(cntTimeCreate);

		pDbg = SystemDebugging::create(this);
		if (!pDbg)
			return procErrLog(-1, "could not create process");

		pDbg->fctDataSendSet(uartTransmit, pUartSwt);
		pDbg->logImmediateSendSet(true); // NOT ALLOWED IN HALF DUPLEX MODE (Single Wire)!

		pDbg->procTreeDisplaySet(false);
		start(pDbg);

		pProc = InfoTesting::create();
		if (!pProc)
			return procErrLog(-1, "could not create process");

		start(pProc);

		HAL_GPIO_TogglePin(LED1_GPIO_PORT, LED1_PIN);

		mState = StDbgReadyWait;

		break;
	case StDbgReadyWait:

		if (!pDbg->ready())
			break;

		HAL_GPIO_TogglePin(LED2_GPIO_PORT, LED2_PIN);

		cmdReg("led1",
			cmdLedOneToggle,
			"", "Toggle LED1",
			"LEDs");

		cmdReg("led2",
			cmdLedTwoToggle,
			"", "Toggle LED2",
			"LEDs");

		cmdReg("reset",
			cmdReset,
			"", "Reset the STM32 microcontroller",
			"Testing");

		/* start interrupts */

		uartErrorsClear();
		HAL_UART_Receive_IT(pUartSwt, (uint8_t *)&bufSwtRx, sizeof(bufSwtRx));

		mState = StMain;

		break;
	case StMain:

		++mCntCycles;

		break;
	default:
		break;
	}

	return Pending;
}

/*
 * This is important!
 * The UART interface is already activated at the beginning of the boot process.
 * If multiple bytes have been received before the call to HAL_UART_Receive_IT(),
 * the overrun flag may be set. In this case, receive interrupts are disabled,
 * even if HAL_UART_Receive_IT() is called.
 */
void StmSupervising::uartErrorsClear()
{
	if (__HAL_UART_GET_FLAG(pUartSwt, UART_FLAG_RXNE))
	{
		volatile uint8_t dummy = (uint8_t)(pUartSwt->Instance->RDR);
		(void)dummy;
	}

	__HAL_UART_CLEAR_PEFLAG(pUartSwt);   // Parity Error
	__HAL_UART_CLEAR_FEFLAG(pUartSwt);   // Framing Error
	__HAL_UART_CLEAR_NEFLAG(pUartSwt);   // Noise Error
	__HAL_UART_CLEAR_OREFLAG(pUartSwt);  // Overrun Error
}

void StmSupervising::processInfo(char *pBuf, char *pBufEnd)
{
#if 1
	dInfo("State\t\t\t%s\n", ProcStateString[mState]);
#endif
	GPIO_PinState nBtnUser;

	nBtnUser = HAL_GPIO_ReadPin(BUTTON_USER_GPIO_PORT,
						BUTTON_USER_PIN);

	dInfo("User button\t\t%s\n", nBtnUser == GPIO_PIN_RESET ? "On" : "Off");
	dInfo("Cycles\t\t%lu\n", mCntCycles);
}

/* static functions */
extern "C" void HAL_UART_RxCpltCallback(UART_HandleTypeDef *huart)
{
	(void)huart;
	pDbg->dataReceived(&bufSwtRx, sizeof(bufSwtRx));
	HAL_UART_Receive_IT(pUartSwt, (uint8_t *)&bufSwtRx, sizeof(bufSwtRx));
}

void StmSupervising::uartTransmit(char *pBuf, size_t len, void *pUser)
{
	UART_HandleTypeDef *pUart = (UART_HandleTypeDef *)pUser;
	HAL_UART_Transmit_IT(pUart, (uint8_t *)pBuf, len);
}

extern "C" void HAL_UART_TxCpltCallback(UART_HandleTypeDef *huart)
{
	(void)huart;
	pDbg->dataSent();
}

void StmSupervising::cmdLedOneToggle(char *pArgs, char *pBuf, char *pBufEnd)
{
	(void)pArgs;
	HAL_GPIO_TogglePin(LED1_GPIO_PORT, LED1_PIN);
	dInfo("LED1 toggled");
	infLog("LED1 toggled");
}

void StmSupervising::cmdLedTwoToggle(char *pArgs, char *pBuf, char *pBufEnd)
{
	(void)pArgs;
	HAL_GPIO_TogglePin(LED2_GPIO_PORT, LED2_PIN);
	dInfo("LED2 toggled");
}

void StmSupervising::cmdReset(char *pArgs, char *pBuf, char *pBufEnd)
{
	HAL_Delay(3000);
	NVIC_SystemReset();
}

uint32_t StmSupervising::cntTimeCreate()
{
	return HAL_GetTick();
}

