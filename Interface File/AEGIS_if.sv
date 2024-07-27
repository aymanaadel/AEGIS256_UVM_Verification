interface AEGIS_if (input bit clk);

    // Design inputs
    logic reset, aegis_start;
    logic encrypt_decrypt;
    logic [255:0] key, IV;
    logic [127:0] plain_text;
    logic [127:0] AD;
    logic [63:0] msglen;
    logic [63:0] adlen;
    // Design outputs
    logic [127:0] cipher;
    logic [127:0] tag;
    logic [127:0] decrypted;
    logic enc_block_done;
    logic dec_block_done;
    logic aegis_done;

	// DUT modport
	modport DUT(
		input clk, reset, aegis_start, encrypt_decrypt, key, IV, plain_text, AD, msglen, adlen,
		output cipher, tag, decrypted, enc_block_done, dec_block_done, aegis_done
	);

endinterface