/*
  This file is part of the DSP-Crowd project
  https://www.dsp-crowd.com

  Author(s):
      - Johannes Natter, office@dsp-crowd.com

  File created on 24.03.2025

  Copyright (C) 2025, Johannes Natter

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program. If not, see <http://www.gnu.org/licenses/>.
*/

#include "main.h"

#include "StmSupervising.h"

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

extern UART_HandleTypeDef huart1;

static uint8_t bufSwtRx;

StmSupervising::StmSupervising()
	: Processing("StmSupervising")
	//, mStartMs(0)
	, mpDbg(NULL)
{
	mState = StStart;
}

/* member functions */

Success StmSupervising::process()
{
	//uint32_t curTimeMs = millis();
	//uint32_t diffMs = curTimeMs - mStartMs;
	//Success success;
#if 0
	dStateTrace;
#endif
	switch (mState)
	{
	case StStart:

		mpDbg = SystemDebugging::create(this);
		if (!mpDbg)
			return procErrLog(-1, "could not create process");

		//mpDbg->procTreeDisplaySet(false);
		start(mpDbg);

		HAL_GPIO_TogglePin(LED1_GPIO_PORT, LED1_PIN);

		mState = StDbgReadyWait;

		break;
	case StDbgReadyWait:

		if (!mpDbg->ready())
			break;

		HAL_GPIO_TogglePin(LED2_GPIO_PORT, LED2_PIN);

		/* start interrupts */

		HAL_UART_Receive_IT(&huart1, &bufSwtRx, sizeof(bufSwtRx));

		mState = StMain;

		break;
	case StMain:

		break;
	default:
		break;
	}

	return Pending;
}

void StmSupervising::processInfo(char *pBuf, char *pBufEnd)
{
#if 1
	dInfo("State\t\t\t%s\n", ProcStateString[mState]);
#endif
}

/* static functions */
extern "C" void HAL_UART_RxCpltCallback(UART_HandleTypeDef *huart)
{
	SingleWireTransfering::dataReceived(&bufSwtRx, sizeof(bufSwtRx));
	HAL_UART_Receive_IT(&huart1, &bufSwtRx, sizeof(bufSwtRx));
}

extern "C" void HAL_UART_TxCpltCallback(UART_HandleTypeDef *huart)
{
	(void)huart;
	SingleWireTransfering::bufTxPending = 0;
}

