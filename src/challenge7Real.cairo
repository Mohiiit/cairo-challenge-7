use starknet::{ContractAddress};
trait IChallenge7Real<TContractState> {
    fn is_complete(self: @TContractState);
    fn get_vitalik_address(self: @TContractState);
}


#[starknet::contract]
mod Challenge7Real {
    use challenge7::challenge7_erc20::IChallenge7ERC20DispatcherTrait;
    use core::traits::Into;
    use starknet::{
        ContractAddress, get_caller_address, get_contract_address,
        class_hash_const, ClassHash
    };
    use challenge7::challenge7_erc20::{
        Challenge7ERC20, IChallenge7ERC20Dispatcher, IChallenge7ERC20
    };
    use starknet::syscalls::deploy_syscall;

    #[storage]
    struct Storage {
        vtoken_address: ContractAddress,
        salt: u128
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        let vitalik_address: ContractAddress = get_contract_address();
        let current_salt: felt252 = self.salt.read().into();
        let ERC20_name = 94920107574606;
        let ERC20_symbol = 1448365131;
        let ERC20_decimals = 18;
        let ERC20_intial_supply: u256 = 100000000000000000000;
        let mut calldata = array![
            ERC20_name.into(),
            ERC20_symbol.into(),
            ERC20_decimals.into(),
            ERC20_intial_supply.try_into().unwrap(),
            vitalik_address.into()
        ];

        let class_hash:ClassHash = class_hash_const::<
            '0x05656764d46c8b517e2bca849ccc4112d870f4ba6125fad88276a09931f18f70'
        >();

        let (new_contract_address, _) = deploy_syscall(
            class_hash, current_salt, calldata.span(), false
        )
            .expect('failed to deploy counter');
        self.salt.write(self.salt.read() + 1);
        self.vtoken_address.write(new_contract_address);
    }

    #[external(v0)]
    impl Challenge7Real of super::IChallenge7Real<ContractState> {
        fn is_complete(self: @ContractState) {
            // let vitalik_address = get_contract_address();
            // let vtoken: ContractAddress = self.vtoken_address.read();
            // let erc20_dispatcher = IChallenge7ERC20Dispatcher { contract_address: vtoken };
            // let current_balance = erc20_dispatcher.balance_of(vitalik_address);
            // assert(current_balance != 0, 'challenge not completed yet');
            // true
        }
        fn get_vitalik_address(self: @ContractState) {
            // self.vtoken_address.read()
        }
    }
}
